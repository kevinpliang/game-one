extends Node

# first we preload the scenes
onready var intro = preload("res://game/Intro.tscn")
onready var main_menu = preload("res://game/menu.tscn")
onready var island_scene = preload("res://world/island.tscn")
onready var cloud_scene = preload("res://world/cloud.tscn")
onready var zee_sprite = preload("res://characters/zee.tscn")
onready var zee2_sprite = preload("res://characters/zee2.tscn")
onready var ish_sprite = preload("res://characters/ish.tscn")
onready var boss_sprite = preload("res://characters/boss.tscn")

onready var shirt = preload("res://objects/shirt.tscn")

# enemies
onready var enemy5 = preload("res://characters/enemy5.tscn")
export(Array, PackedScene) var enemies

var intro_playing = true

func _ready():
	OS.window_maximized = true
	
	Global.node_creation_parent = self
	Global.score = 0
	
	var dead = false
	var boss = false 
	var boss_dead = false # first boss?
	var win = false
	
	# load in scenes
	var intro_instance = intro.instance()
	var menu = main_menu.instance()
	var bg = island_scene.instance()	
	var character = zee_sprite.instance()	
	
	if Global.ish_mode:
		character = ish_sprite.instance()
		Global.instance_node(shirt, Vector2(192,60), Global.node_creation_parent)
	elif Global.zee == 1:
		character = zee_sprite.instance()
		Global.instance_node(shirt, Vector2(192,60), Global.node_creation_parent)
	elif Global.zee == 2:
		character = zee2_sprite.instance()
	add_child(character)
	
	Global.level = 2
	if Global.level == 2:
		bg = cloud_scene.instance()
	
	add_child(bg)
		
	# add them to our main node
	if !Global.intro_played:
		add_child(intro_instance)
		Global.intro_played = true		
		yield(get_tree().create_timer(4), "timeout")
	# add_child(menu)
	#music 
	$music.play()

func _exit_tree():
	$music.stop()
	$queen.stop()
	Global.boss = false;
	Global.enemy_count = 0;
	Global.node_creation_parent = null

func _process(_delta):
	if Global.dodge_tutorial_played:
		intro_playing = false
	randomize()
	if Global.boss:
		$music.stop()
	elif Global.score >= 0 and !Global.boss and !Global.dead and !Global.win:
		# start boss mode
		Global.boss = true
		Global.boss_start_time = OS.get_unix_time()
		$music.stop()
		yield(get_tree().create_timer(1), "timeout")
		$queen.play()
		yield(get_tree().create_timer(7.5), "timeout")
		initiateBoss()
	if Global.boss_dead:
		$music.stop()
		$queen.stop()
		yield(get_tree().create_timer(4), "timeout")
		if !$victory.playing:
				$victory.play()
		
	if Global.win:
		yield(get_tree().create_timer(3.5), "timeout")
		# get_tree().quit()

func initiateBoss():
	var center = Vector2(0,0)
	var boss_spawn = Global.instance_node(boss_sprite,  center, self)

func _on_enemySpawnTimer_timeout():
	randomize()
	if !Global.boss and Global.enemy_count < Global.enemy_max and !intro_playing: # don't spawn lackeys if boss mode
		# don't spawn enemy on island
		var enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
		while (enemy_pos.x > 40 and enemy_pos.x < 330) and (enemy_pos.y > 25 and enemy_pos.y < 170):
			enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
		
		#randomize enemy choice
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var enemyPicker = rng.randi_range(0, enemies.size()-1)
		var enemy = Global.instance_node(enemies[enemyPicker], enemy_pos, self)
		Global.enemy_count += 1
		$enemySpawnTimer.wait_time *= 0.93

#	if Global.win:
#		if Global.enemy_count < 100:
#			# don't spawn enemy on island
#			var enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
#			while (enemy_pos.x > 40 and enemy_pos.x < 330) and (enemy_pos.y > 25 and enemy_pos.y < 170):
#				enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
#
#			#randomize enemy choice
#			var enemy = Global.instance_node(enemy5, enemy_pos, self)
#			Global.enemy_count += 1
#			$enemySpawnTimer.wait_time *= 0.93
