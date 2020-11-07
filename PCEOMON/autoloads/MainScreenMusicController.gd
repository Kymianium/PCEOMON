extends Node
var intro
var loop
var volume = 0

var intro_is_playing = false

var looping = false
func _ready():
	pass # Replace with function body.

func play_loop(looppath : String, begin : bool):
	if (begin):
		loop = load(looppath)
		$Loop.stream = loop
		$Loop.play()
	else:
		$Loop.stop()

func music_volume(volume):
	$Loop.volume_db = volume
	$MainMenu.volume_db = volume
	
func play_loop_with_intro(intropath : String, looppath : String, begin : bool):
	if (looping && begin):
		return
	elif (not looping && begin):
		intro_is_playing = true
		looping = true
		intro = load(intropath)
		loop = load(looppath)
		$MainMenu.stream = intro
		$MainMenu.play()
	else:
		looping = false
		$MainMenu.stop()
		intro_is_playing = false
		$Loop.stop()
	


func _on_MainMenu_finished():
	$Loop.stream = loop
	if (intro_is_playing):
		intro_is_playing = false
		$Loop.play()
