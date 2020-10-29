extends Control

#var first:bool = true

func _ready():
	if OS.window_fullscreen:
		$"CenterContainer/Options/Fullscreen2/FulscreenButton".text = "Desactivar"
	else:
		$"CenterContainer/Options/Fullscreen2/FulscreenButton".text = "Activar"
	
	"""print("first = " + str(metadata.first))
	if metadata.first:
		print("joder")
		if (metadata.fullscreen):
			$CenterContainer/Options/Fullscreen.toggle_mode = true
		else:
			$CenterContainer/Options/Fullscreen.toggle_mode = false
		metadata.first = false"""
	## CAMBIAR EL SINGLETON SKERE


func _on_Back_pressed():
	metadata.first = true
	get_tree().change_scene("res://Title/TitleScreen.tscn")
	



func _on_FulscreenButton_pressed():
	if metadata.fullscreen:
		metadata.fullscreen = false
		OS.window_fullscreen = false
		$"CenterContainer/Options/Fullscreen2/FulscreenButton".text = "Activar"
	else:
		metadata.fullscreen = true
		OS.window_fullscreen = true
		$"CenterContainer/Options/Fullscreen2/FulscreenButton".text = "Desactivar"
