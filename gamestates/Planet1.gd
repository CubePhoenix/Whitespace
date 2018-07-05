extends StaticBody2D

const SCALE_DIVISOR = 16500.0
const COLL_DIVISOR = 18.2

export var mass = 500.0
export var is_finish = false

var radius

func _ready():
	radius = mass / COLL_DIVISOR
	
	if is_finish:
		get_node("Sprite").set_texture(load("res://assets/planets/finish.png"))
	else:
		get_node("Sprite").set_texture(load("res://assets/planets/1.png"))
	
	# Set to size corresponding to mass
	get_node("Sprite").set_scale(Vector2(mass / SCALE_DIVISOR, mass / SCALE_DIVISOR))
	
	var shape = CircleShape2D.new()
	shape.set_radius(radius)
	get_node("CollisionShape").set_shape(shape)