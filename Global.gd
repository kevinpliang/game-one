extends Node

var node_creation_parent = null
var player = null
var dead = false
var boss = false
var boss_dead = false
var enemy_count = 0
var enemy_max = 4
var intro_played = false
var dodge_tutorial_played = false
var ish_mode = false

# 1 is easy (minigun), 2 is normal (smg), 3 is idk (shotgun)
var weapon = 2
var damage = 10
var bullet_speed = 100

var boss_start_time = null

var win = false
var highscore_easy = 0
var highscore = 0
var highscore_hard = 0
var score = 0

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func save():
	var save_dict = {
		"highscore_easy":highscore_easy,
		"highscore":highscore,
		"highscore_hard":highscore_hard,
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
	if lines.size() == 3:
		highscore_easy = lines["highscore_easy"]
		highscore_hard = lines["highscore_hard"]
	savefile.close()
