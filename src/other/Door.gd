extends StaticBody2D

export var type : = 0
export var flipped : = false
var player_in : = false
onready var player = get_node("../../Objects/Player")

signal doortype(type)
signal keylost(type)

func _ready():
	if flipped:
		$AnimatedSprite.flip_h = true
		$DoorPlayerDetect/CollisionShape2D.position.x = $DoorPlayerDetect/CollisionShape2D.position.x * -1
		$CollisionShape2D.position.x = $CollisionShape2D.position.x * -1
		$LightOccluder2D.position.x += 13
	if type == 1: $AnimatedSprite.play("red_closed")
	if type == 2: $AnimatedSprite.play("yellow_closed")
	if type == 3: $AnimatedSprite.play("blue_closed")
	if type == 4: $AnimatedSprite.play("green_closed")

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and player_in:
		if type == 0: open()
		elif player.keys[type - 1]:
			emit_signal("keylost", type)
			open()

func open():
	if type == 0: $AnimatedSprite.play("normal_opening")
	if type == 1: $AnimatedSprite.play("red_opening")
	if type == 2: $AnimatedSprite.play("yellow_opening")
	if type == 3: $AnimatedSprite.play("blue_opening")
	if type == 4: $AnimatedSprite.play("green_opening")
	
	$LightOccluder2D.visible = false
	yield($AnimatedSprite, "animation_finished")
	$DoorPlayerDetect/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true

func _on_PlayerDetection_body_entered(body):
	emit_signal("doortype", type)
	player_in = true

func _on_PlayerDetection_body_exited(body):
	player_in = false
