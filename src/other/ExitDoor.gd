extends Area2D

export var flipped : = false
onready var player = get_node("../../Objects/Player")

signal levelexit()

func _ready():
	if flipped: $AnimatedSprite.flip_h = true
	player.connect("playerexited", self, "player_exit")
	
func player_exit():
	if TimeTrial.time_trial: emit_signal("levelexit")
	else: $AnimatedSprite.play("exit")

func _on_AnimatedSprite_animation_finished(): emit_signal("levelexit")
