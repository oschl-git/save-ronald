extends Actor

#Constants
const BULLET = preload("res://src/other/Bullet.tscn")

#Variables
export var speed : = Vector2(120.0, 250.0)
export var direction : = 1
export var dmgjump : = 170
export var ammo : = 0
export var infinite_ammo : = false

var lives : = 3
var keys : = [false, false, false, false]

var pausescreen

#Stages
var canmove : = true
var canjump : = false
var canshoot : = true
var shooting : = false
var stunned : = false
var invincible : = false
var dead : = false
var canexit : = false
var jumpwaspressed : = false

#Signals
signal playerlives(lives)
signal playerammo(ammo)
signal playerkeys(keys)
signal playerdeath()
signal playerexited()

func _ready():
	if infinite_ammo: emit_signal("playerammo", "inf")
	else: emit_signal("playerammo", ammo)
	
	for door in get_tree().get_nodes_in_group("doors"): #Connects signals to doors (if doors exist)
		door.connect("doortype", $Label, "door_type")
		door.connect("keylost", self, "key_lost")
	
	for key in get_tree().get_nodes_in_group("keys"): #Connects signals to keys (if keys exist)
		key.connect("keycollected", self, "key_collected")
	
	if TimeTrial.time_trial == false: move_cooldown()

func _physics_process(delta):
	check_for_jump() #Checks if player can jump
	input() #Checks player input
	
	if lives <= 0 and dead == false: death()
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	check_danger_collision() #Checks if the player is colliding with dangerous objects
	animate() #Animates player
	
func input():
	if canmove:
		if is_on_floor() and $Sounds/walk.playing == false and velocity.x != 0: $Sounds/walk.play()
		velocity.x = (Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")) * speed.x #Vertical movement
	
		if Input.is_action_pressed("down") and is_on_floor(): #Drop down from one-way platforms
			position.y += 1
		
		if Input.is_action_just_pressed("jump"):
			jump_press_timer() #Checks if jump was pressed shortly before colliding with floor
			
			if canjump:
				velocity.y = -speed.y
				$Sounds/jump.play()
			
		if Input.is_action_just_released("jump") and velocity.y < 0: velocity.y = 0
			
		if Input.is_action_pressed("shoot"): shoot()
		
		if Input.is_action_just_pressed("interact") and canexit: level_exit()

func check_for_jump(): #Modifies the "canjump" variable
	if is_on_floor(): canjump = true
	else:
		yield(get_tree().create_timer(.1, false), "timeout")
		canjump = false

func animate(): #Animates player
	if stunned and dead == false: $AnimatedSprite.play("stunned")
	
	if canmove:
		if velocity.x != 0:
			if shooting == false: $AnimatedSprite.play("run") #Chooses between normal and gun run sprites
			else: $AnimatedSprite.play("run_gun")
		
		if velocity.x > 0: #Choses correct direction and sprite flip
			direction = 1
			$AnimatedSprite.flip_h = false
		elif velocity.x < 0:
			direction = -1
			$AnimatedSprite.flip_h = true
		
		if velocity.y > 0 and !is_on_floor(): #Chooses correct air animation and between normal and gun sprites
			if shooting == false: $AnimatedSprite.play("air_down")
			else: $AnimatedSprite.play("air_down_gun")
		elif velocity.y < 0 and !is_on_floor():
			if shooting == false: $AnimatedSprite.play("air_up")
			else: $AnimatedSprite.play("air_up_gun")
			
		if velocity.x == 0 and velocity.y == 0: #Chooses correct idle animation and between normal and gun sprites
			if shooting == false: $AnimatedSprite.play("idle")
			else: $AnimatedSprite.play("idle_gun")
		
func death():
	dead = true
	canmove = false
	velocity = Vector2.ZERO
	emit_signal("playerdeath")
	$AnimationPlayer.play("normal") #Ensures player is not in invincible animation while dying
	$Sounds/death.play()
	$Area2D/CollisionShape2D.disabled = true
	$LightOccluder2D.visible = false
	set_collision_layer(false)
	$AnimatedSprite.play("death")

func shoot():
	if canshoot == true and (ammo > 0 || infinite_ammo):
		shooting = true #Affects animation
		$Sounds/shoot.play()
		shoot_timer()
		$ShootAnimTimer.start() #Starts timer how long is gun sprite supposed to be displayed
		ammo -= 1
		emit_signal("playerammo", ammo)
		
		var bullet = BULLET.instance()
		var bulletdirection = Vector2(direction, 0)
		bullet.set_bullet_direction(bulletdirection)
		get_parent().add_child(bullet)
		bullet.position = Vector2(position.x + 12 if direction == 1 else position.x - 12, position.y)
	
func level_exit():
	emit_signal("playerexited")
	set_physics_process(false)
	$LightOccluder2D.visible = false
	$Area2D/CollisionShape2D.set_deferred('disabled', true)
	visible = false
	
func _on_Area2D_body_entered(body): if invincible == false: hurt()

func _on_Area2D_area_entered(area):
	if "EnemyBullet" in area.name and invincible == false: hurt()
	
	if "HitArea" in area.name and invincible == false: hurt()
	
	if "AmmoPickup" in area.name:
		ammo += 5
		emit_signal("playerammo", ammo)
	
	if "HeartPickup" in area.name:
		if lives <= 2: lives += 1
		emit_signal("playerlives", lives)
	
	if "ExitDoor" in area.name:
		canexit = true
		
func _on_Area2D_area_exited(area):
	if "ExitDoor" in area.name:
		canexit = false
	
func check_danger_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("danger"):
			lives = 0
			emit_signal("playerlives", lives)

func jump_press_timer(): #Checks if jump was pressed shortly before colliding with floor
	jumpwaspressed = true
	yield(get_tree().create_timer(.1, false), "timeout")
	jumpwaspressed = false

func shoot_timer(): #Adds delay between shooting
	canshoot = false
	yield(get_tree().create_timer(.3, false), "timeout")
	canshoot = true

func shoot_anim_timer(): #While this timer is active, shooting sprite will be displayed
	shooting = false	
	yield(get_tree().create_timer(3, false), "timeout")
	shooting = true

func _on_ShootAnimTimer_timeout(): shooting = false

func hurt():
	stunned(1)
	invincible(2)
	velocity.x = 0
	lives -= 1
	emit_signal("playerlives", lives)
	if is_on_floor(): velocity.y -= dmgjump
	if lives >= 1: $Sounds/hurt.play()

func invincible(time):
	invincible = true
	$AnimationPlayer.play("invincible")
	yield(get_tree().create_timer(time, false), "timeout")
	invincible = false
	$AnimationPlayer.play("normal")
	
func stunned(time):
	stunned = true
	$LightOccluder2D.position.y = 5
	canmove = false
	yield(get_tree().create_timer(time, false), "timeout")
	stunned = false
	$LightOccluder2D.position.y = 0
	
	if pausescreen != null: #Ensures player can't start moving while time trial menu is active.
		if dead == false and pausescreen.timetrial_menu == false: canmove = true 
	else: canmove = true
	
func move_cooldown(): #Stops the player from moving at the beginning of a level
	canmove = false
	yield(get_tree().create_timer(.5, false), "timeout")
	canmove = true

func key_collected(type):
	keys[type - 1] = true
	emit_signal("playerkeys", keys)

func key_lost(type):
	keys[type - 1] = false
	emit_signal("playerkeys", keys)
