extends Node

# first we preload the scenes
onready var intro = preload("res://game/Intro.tscn")
onready var main_menu = preload("res://game/menu.tscn")

# backgrounds
onready var island = preload("res://world/island.tscn")
onready var sky = preload("res://world/sky.tscn")
onready var cloud = preload("res://world/cloud.tscn")

# characters
onready var zee = preload("res://characters/zee.tscn")
onready var zee2 = preload("res://characters/zee2.tscn")
onready var ish = preload("res://characters/ish.tscn")
onready var boss_sprite = preload("res://characters/boss.tscn")

onready var shirt = preload("res://objects/shirt.tscn")

# enemies
onready var enemy5 = preload("res://characters/enemies/enemy5.tscn")
var enemies
export(Array, PackedScene) var enemies_1
export(Array, PackedScene) var enemies_2

var intro_playing = true

# music
var theme_1 = load("res://game/sounds/toadv2.ogg")
var theme_2 = load("res://game/sounds/river.ogg")
var boss_1 = load("res://game/sounds/queenA.ogg")
var victory = load("res://game/sounds/yong.ogg")

func _ready():
	OS.window_maximized = true
	
	Global.node_creation_parent = self
	Global.score = 0
	Global.vulnerable = true
	
	var dead = false
	var boss_mode = false 
	var boss1_dead = false # first boss?
	var win = false
	
	# load in scenes
	var intro_instance = intro.instance()
	var menu = main_menu.instance()	
	var character = zee.instance()	
	
	# DEV
	Global.level = 2
	Global.zee = 2
	Global.boss1_dead = true
	
	loadLevel()
	
	if Global.ish_mode:
		character = ish.instance()
	elif Global.zee == 1:
		character = zee.instance()
	elif Global.zee == 2:
		character = zee2.instance()
	add_child(character)
	
	$music.play()
	# add them to our main node
	if !Global.intro_played:
		add_child(intro_instance)
		Global.intro_played = true		
		yield(get_tree().create_timer(4), "timeout")
	intro_playing = false
	# add_child(menu)

func _exit_tree():
	$music.stop()
	Global.boss_mode = false;
	Global.enemy_count = 0;
	Global.node_creation_parent = null

func _process(_delta):
	if Global.score >= 0 and !Global.boss_mode and !Global.dead and !Global.win and !Global.boss1_dead:
		# start boss1 encounter if its not boss mode
		print("starting boss mode")
		Global.boss_mode = true
		Global.boss_start_time = OS.get_unix_time()
		$music.stop()
		yield(get_tree().create_timer(1), "timeout")
		$music.stream = boss_1
		$music.play()
		yield(get_tree().create_timer(7.5), "timeout")
		initiateBoss1()
	elif Global.boss1_dead and Global.level == 1 and $music.get_stream() != victory:
		# controls music ONLY
		$music.stop()
		$music.stream = victory
		$music.set_volume_db(-15)
		yield(get_tree().create_timer(2.5), "timeout")
		$music.play()
	if Global.win:
		get_tree().quit()


func initiateBoss1():
	var center = Vector2(0,0)
	var boss_spawn = Global.instance_node(boss_sprite,  center, self)

func loadLevel():
	Global.vulnerable = true
	var crosshair = ImageTexture.new()
	if Global.level == 1:
		Global.instance_node(island, Vector2(0,0), Global.node_creation_parent)
		crosshair.load("res://objects/sprites/crosshair.png")
		enemies = enemies_1
	elif Global.level == 1.5:
		$music.set_volume_db(-10)
		$music.stream = theme_2
		$music.play()
		Global.instance_node(sky, Vector2(0,0), Global.node_creation_parent)
		enemies = []
	elif Global.level == 2:
		if !$music.playing:
			$music.stream = theme_2
			$music.play()
		Global.instance_node(cloud, Vector2(0,0), Global.node_creation_parent)
		crosshair.load("res://objects/sprites/crosshair-black.png")
		enemies = enemies_2
	Input.set_custom_mouse_cursor(crosshair)

func _on_enemySpawnTimer_timeout():
	randomize()
	if !Global.boss_mode and Global.enemy_count < Global.enemy_max and !intro_playing: # don't spawn lackeys if boss mode
		# don't spawn enemy on island
		var enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
		while (enemy_pos.x > 40 and enemy_pos.x < 330) and (enemy_pos.y > 25 and enemy_pos.y < 170):
			enemy_pos = Vector2(rand_range(10, 374), rand_range(10,206))
		
		#randomize enemy choice
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		if(enemies.size() > 0):
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
