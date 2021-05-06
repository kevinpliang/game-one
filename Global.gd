extends Node

var node_creation_parent = null
var camera = null
var player = null
var dead = false

var highscore = 0;
var score = 0;

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func save():
	var save_dict = {
		"highscore":highscore
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass("user://savegame.save", File.WRITE, "ab123")
	save_game.store_line(to_json(save()))
	
func load_game():
	var savefile = File.new()
	if not savefile.file_exists("user://savegame.save"):
		print("Error! No save file.")
		return
	savefile.open_encrypted_with_pass("user://savegame.save", File.READ, "ab123")
	var lines = parse_json(savefile.get_line())
	highscore = lines["highscore"]
	savefile.close()
