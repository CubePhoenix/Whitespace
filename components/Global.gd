extends Node

# Constants
const level_count = 3

# Persistent Player Data
var level_solved
var level_playing

func _ready():
	level_solved = 1
	level_playing = 1