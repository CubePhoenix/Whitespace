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
	get_node("Success").hide()
	get_node("LevelOverview").show()

func _on_RestartButton_pressed():
	emit_signal("restartbutton_pressed")


func _on_NextButton_pressed():
	emit_signal("nextbutton_pressed")

func _on_BackButton_pressed():
	get_node("LevelOverview").hide()
	get_node("Success").show()

func show_success():
	if get_node("/root/Global").get("level_solved") >= get_node("/root/Global").get("level_count"):
		get_node("Success/VBoxContainer/HBoxContainer/HSplitContainer/HSplitContainer/NextButton").hide()
	
	get_node("Success").show()
	
func _level_selected(lvl):
	emit_signal("level_selected", lvl)