extends Node

# Constants
var level_count

# Persistent Player Data
var level_solved
var level_playing

func _ready():
	level_solved = 1
	level_playing = 1
	
	load_game()
	
	level_count = len(list_files_in_directory("res://levels"))
	
func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()

    return files

func save_game():
	var data = {
		"level_solved" : str(level_solved),
		"level_playing" : str(level_playing)
	}
	
	var save_game = File.new()
	save_game.open("user://save.dat", File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()
	
func load_game():
	var dict = {}
	
	var save_game = File.new()
	if not save_game.file_exists("user://save.dat"):
		return # Error! We don't have a save to load.
	
	save_game.open("user://save.dat", File.READ)
	dict = parse_json(save_game.get_as_text())
	
	level_solved = str(dict["level_solved"]).to_int()
	level_playing = str(dict["level_playing"]).to_int()
	
func set_level_solved(value):
	level_solved = value
	save_game()

func get_level_solved():
	return level_solved
	
func get_level_playing():
	return level_playing
	
func set_level_playing(value):
	level_playing = value
	save_game()