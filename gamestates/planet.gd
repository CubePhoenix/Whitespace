extends StaticBody2D

const SCALE_DIVISOR = 8250.0
const COLL_DIVISOR = 9.1

export var mass = 500.0
export var is_finish = false

var radius

func _ready():
	radius = mass / COLL_DIVISOR
	
	if is_finish:
		get_node("Sprite").set_texture(preload("res://assets/planets/finish.png"))
	else:
		var planet_count = len(list_valid_files_in_directory("res://assets/planets/"))
		var planet = (randi() % (planet_count-1))+1
		
		get_node("Sprite").set_texture(load("res://assets/planets/" + str(planet) + ".png"))
	
	# Set to size corresponding to mass
	get_node("Sprite").set_scale(Vector2(mass / SCALE_DIVISOR, mass / SCALE_DIVISOR))
	
	var shape = CircleShape2D.new()
	shape.set_radius(radius)
	get_node("CollisionShape").set_shape(shape)
	
func list_valid_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".png"):
			files.append(file)
			
	dir.list_dir_end()
	return files