extends Actor

onready var player = get_node("../../Objects/Player")

var health : = 150
var phase2health : = 60
var direction : = -1
var speed : = 0
var jump : = 300

var intro : = true
var phase1 : = false
var phase2 : = false
var phase3 : = false
var phase4 : = false
var dead : = false

var invincible : = true
var stunned : = false
var phaseprogress : = false
var changingtoblue : = false
var blue : = false

var madfat_intro : = load("res://sound/music/madfat_intro.ogg")
var madfat_music : = load("res://sound/music/madfat.ogg")
var madfat_victory : = load("res://sound/music/madfat_victory.ogg")

signal health_updated(health)
signal show_health_bar()
signal death()

func _ready():
	set_physics_process(false)
	MusicManager.change_music_no_loop(madfat_intro)

func _physics_process(delta):
	
	if intro:
		intro()
		animate()
	elif health == 0 and dead == false: death()
	elif dead == false:
		if phaseprogress == false: phase_manager()
		animate()
		
		if phase1: phase1()
		elif phase2: phase2()
		elif phase3: phase3()
		elif phase4: phase4()
			
		velocity.x = speed * direction
		
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func animate():
	if direction == -1: $AnimatedSprite.flip_h = true
	else: $AnimatedSprite.flip_h = false
	
	if is_on_floor():
		if stunned == false:
			if blue: $AnimatedSprite.play("running_blue")
			else: $AnimatedSprite.play("running")
			if $running.playing == false: $running.play()
		else: 
			if health < phase2health and changingtoblue == true:
				$AnimatedSprite.play("stunned_changing_colour")
			elif blue: $AnimatedSprite.play("stunned_blue")
			else: $AnimatedSprite.play("stunned")
			$running.stop()
	else:
		if velocity.y < 0:
			if blue: $AnimatedSprite.play("air_up_blue")
			else: $AnimatedSprite.play("air_up")
		else:
			if blue: $AnimatedSprite.play("falling_blue")
			else: $AnimatedSprite.play("falling")

var healthshown : = false
func intro():
	if is_on_floor():
		stunned()
		yield(get_tree().create_timer(3, false), "timeout")
		emit_signal("show_health_bar")
		invincible = false
		intro = false


var timesran : = 1
var phasetoggle : = 0
func phase_manager():
	phase1 = false
	phase2 = false
	phase3 = false
	
	if timesran == 0:
		stunned()
		timesran += 1
	elif timesran == 1 and stunned == false:
		timesran = 0
		if not blue:
			if phasetoggle == 0:
				phase2 = true
				phasetoggle = 1
			else:
				phase3 = true
				phasetoggle = 0
		else:
			if phasetoggle == 0:
				phase4 = true
				phasetoggle = 1
			else:
				phase1 = true
				phasetoggle = 0
		
		phaseprogress = true
			

var timesphase1 : = 0
func phase1(): #infinite jumping
	if stunned == false && is_on_floor(): 
		velocity.y = -jump
		$running.stop()
		$jump.play()
		speed = abs(player.position.x - position.x) * 2
		if player.position.x < position.x:
			direction = -1
		else:
			direction = 1
		timesphase1 += 1
	if timesphase1 == 10:
		timesphase1 = 0
		phaseprogress = false

var timesphase2 : = 0
func phase2(): #running + jumping
	if stunned == false:
		speed = 150
		if is_on_wall():
			timesphase2 += 1
			direction = direction * -1
		if is_on_floor():
			if ((direction == 1 && player.position.x - position.x > 60 && player.position.x - position.x < 90)
				|| (direction == -1 && player.position.x - position.x < -60 && player.position.x - position.x > -90)):
				$running.stop()
				$jump.play()
				velocity.y = -jump
		if timesphase2 == 6:
			timesphase2 = 0
			phaseprogress = false

var timesphase3 : = 0
func phase3(): # infinite running
	if stunned == false:
		speed = 200
		if is_on_wall():
			direction = direction * -1
			timesphase3 += 1
		if timesphase3 == 5:
			timesphase3 = 0
			phaseprogress = false

var timesphase4 : = 0
func phase4(): #running + always jumping
	if stunned == false:
		speed = 150
		if is_on_wall():
			timesphase4 += 1
			direction = direction * -1
		if is_on_floor():
			velocity.y = -jump
			$running.stop()
			$jump.play()
		if timesphase4 == 6:
			timesphase4 = 0
			phaseprogress = false

var musicplaying : = false
func stunned():
	if stunned == false:
		$hurt.play()
		stunned = true
		speed = 0
		$LightOccluder2D.position.y = 8
		if health < phase2health and blue == false: change_to_blue()
		yield(get_tree().create_timer(3, false),"timeout")
		$LightOccluder2D.position.y = 0
		stunned = false
		if musicplaying == false:
			musicplaying = true
			MusicManager.change_music(madfat_music)
			
func change_to_blue():
	changingtoblue = true
	yield(get_tree().create_timer(1.2, false),"timeout")
	changingtoblue = false
	blue = true
	
func death():
	MusicManager.change_music_no_loop(madfat_victory)
	$running.stop()
	$death.play()
	velocity.x = 0
	dead = true
	stunned = false
	$HitArea/CollisionPolygon2D.set_deferred("disabled", true)
	$LightOccluder2D.visible = false
	$AnimatedSprite.play("death_blue")
	yield(get_tree().create_timer(2.5, false), "timeout")
	emit_signal("death")

func _on_HitArea_area_entered(area):
	if "Bullet" in area.name and invincible == false:
		health -= 1
		emit_signal("health_updated", health)

var activated : = false
func _on_ActivationArea_body_entered(body):
	if activated == false:
		visible = true
		activated = true
		$fall.play()
		set_physics_process(true)
