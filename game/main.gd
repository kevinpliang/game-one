extends Node

# first we preload the scenes
onready var main_menu = preload("res://game/menu.tscn")
onready var island_scene = preload("res://world/island.tscn")
onready var zee_sprite = preload("res://characters/zee.tscn")
onready var boss_sprite = preload("res://characters/boss.tscn")

# enemies
onready var enemy1 = preload("res://characters/enemy1.tscn")
export(Array, PackedScene) var enemies

func _ready():
	OS.window_maximized = true
	
	Global.node_creation_parent = self
	Global.score = 0
	
	#music 
	$music.play()
	
	# load in scenes
	var menu = main_menu.instance()
	var island_bg = island_scene.instance()
	var character = zee_sprite.instance()
	
	# add them to our main node
	add_child(island_bg)
	add_child(character)
	# add_child(menu)

func _exit_tree():
	$music.stop()
	$queen.stop()
	Global.boss = false;
	Global.node_creation_parent = null

func _process(_delta):
	randomize()
	if Global.boss:
		$music.stop()
	elif Global.score >= 200 and !Global.boss and !Global.dead:
		# start boss mode
		print("boss mode!")
		Global.boss = true
		Global.boss_start_time = OS.get_unix_time()
		$music.stop()
		yield(get_tree().create_timer(1), "timeout")
		$queen.play()
		yield(get_tree().create_timer(7.5), "timeout")
		initiateBoss()
	if Global.win:
		print("You won!")
		get_tree().quit()

func initiateBoss():
	var center = Vector2(0,0)
	var boss = Global.instance_node(boss_sprite,  center, self)

func _on_enemySpawnTimer_timeout():
	randomize()
	if !Global.boss and Global.enemy_count < 100: # don't spawn lackeys if boss mode
		# don't spawn enemy on island
		var enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
		while (enemy_pos.x > 40 and enemy_pos.x < 330) and (enemy_pos.y > 25 and enemy_pos.y < 170):
			enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
		
		#randomize enemy choice
		var enemyPicker = round(rand_range(0, enemies.size()-1))		
		var enemy = Global.instance_node(enemies[enemyPicker], enemy_pos, self)
		Global.enemy_count += 1
		$enemySpawnTimer.wait_time *= 0.93
