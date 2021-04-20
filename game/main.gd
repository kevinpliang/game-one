extends Node

# first we preload the scenes
onready var main_menu = preload("res://game/menu.tscn")
onready var zee_sprite = preload("res://characters/zee.tscn")
onready var island_scene = preload("res://world/island.tscn")


func _ready():
	# load in scenes
	var menu = main_menu.instance()
	var character = zee_sprite.instance()
	var island_bg = island_scene.instance()
	
	# add them to our main node
	add_child(island_bg)
	add_child(character)
	add_child(menu)
