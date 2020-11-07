extends Node
var intro
var loop


var isintitle = false
func _ready():
	pass # Replace with function body.
	



func titlescreen(title : bool):
	intro = load("res://OST/IntroAndMenu/titlescreen.ogg")
	loop = load("res://OST/IntroAndMenu/titlescreen_loop.ogg")
	if (isintitle && title):
		return
	elif (not isintitle && title):
		isintitle = true
		$MainMenu.stream = intro
		$MainMenu.play()
	else:
		isintitle = false
		$Loop.stop()
		$MainMenu.stop()
	


func _on_MainMenu_finished():
	$Loop.stream = loop
	if (isintitle):
		$Loop.play()
