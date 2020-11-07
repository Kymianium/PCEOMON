extends Control

#var first:bool = true

func _ready():
	if OS.window_fullscreen:
		$"CenterContainer/Options/Fullscreen2/FulscreenButton".text = "Desactivar"
	else:
		$"CenterContainer/Options/Fullscreen2/FulscreenButton".text = "Activar"
	$"CenterContainer/Options/Volume/VolumeValue".text = str(metadata.volumevalue)
	
	
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


func _on_minus_pressed():
	if (metadata.volumevalue != 0):
		metadata.volumevalue -= 1
		$"CenterContainer/Options/Volume/VolumeValue".text = str(metadata.volumevalue)
		for music in $"/root/MainScreenMusicController".get_children():
			if metadata.volumevalue != 0:
				music.volume_db -= 5
			else:
				music.volume_db = -80
		


func _on_plus_pressed():
	if (metadata.volumevalue != 10):
		metadata.volumevalue += 1
		$"CenterContainer/Options/Volume/VolumeValue".text = str(metadata.volumevalue)
		for music in $"/root/MainScreenMusicController".get_children():
			if metadata.volumevalue != 1:
				music.volume_db += 5
			else:
				music.volume_db = -45
