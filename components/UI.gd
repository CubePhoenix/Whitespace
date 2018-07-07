extends CanvasLayer

signal restartbutton_pressed
signal nextbutton_pressed
signal level_selected

func _ready():
	# Connect player to signals
	connect("restartbutton_pressed", get_parent().get_node("Player"), "_on_UI_restartbutton_pressed")
	connect("nextbutton_pressed", get_parent().get_node("Player"), "_on_UI_nextbutton_pressed")
	connect("level_selected", get_parent().get_node("Player"), "_on_UI_level_selected")

func _on_MenuButton_pressed():
	get_node("LevelOverview").show()
	get_node("AnimationPlayer").play("Levels")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_node("Success").hide()

func _on_RestartButton_pressed():
	get_node("AnimationPlayer").play("SuccessRestart")
	yield(get_node("AnimationPlayer"), "animation_finished")
	emit_signal("restartbutton_pressed")


func _on_NextButton_pressed():
	get_node("AnimationPlayer").play("SuccessNextLevel")
	yield(get_node("AnimationPlayer"), "animation_finished")
	emit_signal("nextbutton_pressed")

func _on_BackButton_pressed():
	get_node("Success").show()
	get_node("AnimationPlayer").play("LevelsBack")
	yield(get_node("AnimationPlayer"), "animation_finished")
	get_node("LevelOverview").hide()
	

func show_success():
	if get_node("/root/Global").get("level_playing") >= get_node("/root/Global").get("level_count"):
		get_node("Success/VBoxContainer/HBoxContainer/HSplitContainer/HSplitContainer/NextButton").hide()
	else:
		get_node("Success/VBoxContainer/HBoxContainer/HSplitContainer/HSplitContainer/NextButton").show()
	
	get_node("Success").show()
	get_node("AnimationPlayer").play("Success")
	yield(get_node("AnimationPlayer"), "animation_finished")
	
func _level_selected(lvl):
	get_node("AnimationPlayer").play("LevelsSelected")
	yield(get_node("AnimationPlayer"), "animation_finished")
	emit_signal("level_selected", lvl)