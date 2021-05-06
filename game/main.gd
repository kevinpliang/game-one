extends Node

# first we preload the scenes
onready var main_menu = preload("res://game/menu.tscn")
onready var island_scene = preload("res://world/island.tscn")
onready var zee_sprite = preload("res://characters/zee.tscn")

# enemies
onready var enemy1 = preload("res://characters/enemy1.tscn")
export(Array, PackedScene) var enemies

func _ready():
	Global.node_creation_parent = self
	Global.score = 0
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
	while (enemy_pos.x > 40 and enemy_pos.x < 330) and (enemy_pos.y > 25 and enemy_pos.y < 170):
		enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
	
	#randomize enemy
	var enemyPicker = round(rand_range(0, enemies.size()-1))		
	var enemy = Global.instance_node(enemies[enemyPicker], enemy_pos, self)
	$enemySpawnTimer.wait_time *= 0.95
