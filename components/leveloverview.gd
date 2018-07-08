extends CenterContainer

func _ready():
	var level_solved = get_node("/root/global").get_level_solved()
	var level_count = get_node("/root/global").get("level_count")
	
	for i in range(1, level_solved + 1):
		get_node("VSplitContainer/VSplitContainer/Levels").add_child(get_button(i))
	for i in range(level_solved + 1, level_count + 1):
		get_node("VSplitContainer/VSplitContainer/Levels").add_child(get_button(i, true))
		

func get_button(number, is_locked=false):
	var button
	if is_locked:
		button = load("res://components/lockedlevelbutton.tscn").instance()
	else:
		button = load("res://components/levelbutton.tscn").instance()
		button.connect("lvlselected", get_parent(), "_level_selected")
	
	button.set_text(str(number))
	
	return button