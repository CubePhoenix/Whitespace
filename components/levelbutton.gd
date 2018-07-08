extends Button

signal lvlselected

func _ready():
	connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	emit_signal("lvlselected", text.to_int())