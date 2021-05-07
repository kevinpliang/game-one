extends Camera2D

onready var flash = $flash_sprite
onready var tween = $tween

var strength = 0.15
var speed = 0.25

func _ready():
	Global.camera = self
	
func _exit_tree():
	Global.camera = null

func _process(delta):
	pass
