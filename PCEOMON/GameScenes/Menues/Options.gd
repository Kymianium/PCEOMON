extends Control

func _ready():
#	if (OS.window_fullscreen):
#		$CenterContainer/Options/Fullscreen.toggle_mode = true
#	else:
#		$CenterContainer/Options/Fullscreen.toggle_mode = false
		
	## CAMBIAR EL SINGLETON SKERE
	pass

func _on_Fullscreen_toggled(button_pressed):
	if button_pressed == true:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false


func _on_Back_pressed():
	get_tree().change_scene("res://Title/TitleScreen.tscn")
