extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LogoAnimation.play("QAnimation")
	$IntroMusic.play()
	#ESTOY HAY QUE QUITARLO, LA MUSICA ME ESTABA REVENTANDO LOS OIDOS ESTA MUY ALTA
	$"/root/MainScreenMusicController".volume = -30
	$"/root/MainScreenMusicController".music_volume(-30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_mouse_button_pressed(1) or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_ENTER):   # si se pulsa el boton izq del raton o el espacio
		$LogoAnimation.stop()
		$IntroMusic.stop()
		get_tree().change_scene("res://Title/TitleScreen.tscn")


func _on_LogoAnimation_animation_finished(_anim_name):
	get_tree().change_scene("res://Title/TitleScreen.tscn")
