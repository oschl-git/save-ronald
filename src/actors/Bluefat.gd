extends Redfat

var chargetimer
export var bluefat_lives = 7

func _ready():
	lives = bluefat_lives
	bluefat = true
	set_up_charge_timer()

func _physics_process(delta):
	if charging == true and (not $FloorChecker.is_colliding() or is_on_wall()):
		direction = direction * -1
		change_direction()
	
	if $PlayerChecker.is_colliding() and stunned == false:
		chargetimer.start()
	
func set_up_charge_timer():
	chargetimer = Timer.new()
	chargetimer.set_wait_time(6)
	chargetimer.connect("timeout", self, "on_charge_timer_complete")
	add_child(chargetimer)

func on_charge_timer_complete():
	if stunned == false and isdead == false:
		$AnimatedSprite.play("walking")
		charging = false

func _on_DeathArea_area_entered(area):
	if "Bullet" in area.name:
		$hurt.play()
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("hit")
		lives -= 1
