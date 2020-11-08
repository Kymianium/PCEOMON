extends Control

var scene_path_to_load

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animations.play("Logo")
	$FadeIn.fade_out()
	$"/root/MainScreenMusicController".play_loop_with_intro("res://OST/IntroAndMenu/titlescreen.ogg", "res://OST/IntroAndMenu/titlescreen_loop.ogg", true)
	$Menu/CenterRow/Play.grab_focus()
	for button in $Menu/CenterRow.get_children():
		button.connect("pressed", self, "_on_button_pressed", [button.scene_to_load])


func _on_button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()


func _on_FadeIn_fade_in_finished():
	get_tree().change_scene(scene_path_to_load)


func _on_FadeIn_fade_out_finished():
	$FadeIn.hide()


func _on_Play_pressed():
	$"/root/MainScreenMusicController".play_loop_with_intro("","",false)
