extends Label

var areaname = ""

func _ready():
	Auto.connect("inputchange", self, "input_changed")

func _on_Area2D_area_entered(current_area):
	areaname = current_area.name
	change_label()

func _on_Area2D_area_exited(current_area): visible = false
func input_changed(): change_label()

func change_label():
	if "ExitDoor" in areaname:
		if Auto.input == 0: set_text("[E]/[Ctrl]")
		if Auto.input == 1: set_text("(X)")
		visible = true
		
	if "JumpDownHint" in areaname:
		set_text("[Down]")
		visible = true
	
	if "ShootTutorial" in areaname:
		if Auto.input == 0: set_text("[Space] shoot")
		if Auto.input == 1: set_text("[RB] shoot")
		visible = true
		
func door_type(type):
	if type == 0 or get_parent().keys[type - 1]:
		if Auto.input == 0: set_text("[E]/[Ctrl]")
		if Auto.input == 1: set_text("(X)")
	else: set_text("locked")
	visible = true
