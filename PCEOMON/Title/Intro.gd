extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LogoAnimation.play("QAnimation")
	$IntroMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_IntroMusic_finished():
	get_tree().change_scene("res://Title/TitleScreen.tscn")
