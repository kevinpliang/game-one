extends Node

# first we preload the scenes
onready var main_menu = preload("res://game/menu.tscn")
onready var island_scene = preload("res://world/island.tscn")
onready var zee_sprite = preload("res://characters/zee.tscn")
onready var enemy1 = preload("res://characters/enemy1.tscn")

func _ready():
	Global.node_creation_parent = self
	# load in scenes
	var menu = main_menu.instance()
	var island_bg = island_scene.instance()
	var character = zee_sprite.instance()
	
	# add them to our main node
	add_child(island_bg)
	add_child(character)
	# add_child(menu)
	
func _exit_tree():
	Global.node_creation_parent = null

func _on_enemySpawnTimer_timeout():
	var enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
	while (enemy_pos.x > 100 and enemy_pos.x < 200) and (enemy_pos.y > 40 and enemy_pos.y < 160):
		enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
	Global.instance_node(enemy1, enemy_pos, self)
