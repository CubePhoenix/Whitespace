extends KinematicBody2D

const SENSITIVITY_DIVISOR = 20
const GRAVITY_MULTIPLIER = 0.002

enum gamestates {
	FINISHED_SUCCESS, FINISHED_FAILURE, FLYING, AWAIT_INPUT
}

# current gamestate of the game
var state
var direction
var original_position
var finished

func _ready():
	# initialization of global variables
	state = gamestates.AWAIT_INPUT
	direction = Vector2(0, 0)
	original_position = position
	finished = 0.0

func _physics_process(delta):
	# call sub-process function depending on gamestate
	if state == gamestates.AWAIT_INPUT:
		process_await_input(delta)
	elif state == gamestates.FLYING:
		process_flying(delta)
	else:
		process_finished(delta)


func process_await_input(delta):
	if (Input.is_mouse_button_pressed(BUTTON_LEFT)): # Touch input is registered as left mouse button
		# get touch location relative to player satellite position
		var dirnsquare = (get_position() - get_viewport().get_mouse_position()) / SENSITIVITY_DIVISOR
		direction = Vector2(-sqroot(dirnsquare.x), -sqroot(dirnsquare.y))
		
		# Rotate the rocket to the touch input
		rotate_to(direction)
		
		# Thrust animation
		get_node("Particles/Thruster1").set_emitting(true)
		get_node("Particles/Thruster2").set_emitting(true)
		get_node("Timers/ThrustTimer").start()
		yield(get_node("Timers/ThrustTimer"), "timeout")
		get_node("Particles/Thruster1").set_emitting(false)
		get_node("Particles/Thruster2").set_emitting(false)
		
	elif (direction != Vector2(0, 0)): # if a direction was set previously
		state = gamestates.FLYING
	
func process_flying(delta):
	# fly further in direction (adjust according to gravitation)
	# and finish if satellite hit planet (win for right planet, lose for wrong)
	# restart level if there is user input

	for planet in get_parent().get_node("Planets").get_children():
		direction += get_gravitational_force(planet)
	
	var col = move_and_collide(direction)
	
	# Rotate hitbox and texture
	rotate_to(direction)
	
	# if a collision occured
	if col:
		if col.get_collider().get("is_finish"):
			state = gamestates.FINISHED_SUCCESS
			
			# Rotate so rocket stands
			rotate_to(get_position() - get_node_position(col.get_collider()))
			# TODO set distance from planet
		else:
			state = gamestates.FINISHED_FAILURE
	
	if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
		reset_level()

func process_finished(delta):
	# display end screen 
	if finished == 0.0: # if not set yet
		finished = delta
		
		if state == gamestates.FINISHED_SUCCESS:
			get_parent().get_node("UI").show_success()
		else:
			# Play the explosion and reset
			get_node("Timers/ResetTimer").start()
			get_node("Sprite").hide()
			get_node("Particles/Explosion").set_emitting(true)
			yield(get_node("Timers/ResetTimer"), "timeout")
			get_node("Sprite").show()
			get_node("Particles/Explosion").set_emitting(false)
			reset_level()
	
	# TODO buttons on end screen instead of just clicking
	#if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
	#	reset_level()

func get_gravitational_force(planet):
	# Get planets properties
	var mass = planet.mass
	var pos = get_node_position(planet)
	var force = Vector2(0, 0)
	
	# Get relative position
	var rel_pos = get_position() - pos
	
	# Check if we're in range of the gravitational force
	if (rel_pos.x < mass) and (rel_pos.y < mass):
		
		# Calculate distance from planet
		var distance = sqroot((rel_pos.x * rel_pos.x) + (rel_pos.y * rel_pos.y))

		# Calculate force on the player
		force = (Vector2(- sqroot(rel_pos.x), - sqroot(rel_pos.y)) / Vector2(distance, distance)) \
			* Vector2(GRAVITY_MULTIPLIER, GRAVITY_MULTIPLIER) * Vector2(mass, mass)
	return force


func get_position():
	return position

func get_node_position(node):
	return node.get("position")

func reset_level():
	get_parent().get_node("UI/Success").hide()
	
	state = gamestates.AWAIT_INPUT
	position = original_position
	finished = 0.0
	direction = Vector2(0, 0)
	
	# TODO Spawn animation
	
func sqroot(fl):
	if fl >= 0:
		return sqrt(fl)
	else:
		return -sqrt(abs(fl))
		
func rotate_to(vec):
	rotate(-atan2(-vec.x, -vec.y) - rotation)

func _on_UI_nextbutton_pressed():
	var level = get_node("/root/Global").get("level_playing") + 1
	get_node("/root/Global").set("level_playing", level)
	
	if (get_node("/root/Global").get("level_solved") < level):
		get_node("/root/Global").set("level_solved", level)
	
	get_tree().change_scene("res://levels/" + str(level) + ".tscn")


func _on_UI_restartbutton_pressed():
	reset_level()


func _on_UI_level_selected(lvl):
	get_node("/root/Global").set("level_playing", lvl)
	get_tree().change_scene("res://levels/" + str(lvl) + ".tscn")
