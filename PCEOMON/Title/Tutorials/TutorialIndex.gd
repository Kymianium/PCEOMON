extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current
var increasing_value = 0
var delta_accumulated = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current = $TutorialsAndText/Tutorial/Text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_accumulated+=delta
	if delta_accumulated>=0.1:
		delta_accumulated-=0.1
		increasing_value = (increasing_value + 1) % 100
	#COMBAT
	$TutorialsAndText/Tutorial/Combat/VerticalContainter/PCEOMONES/HP.value = 100 - increasing_value
	$TutorialsAndText/Tutorial/Combat/VerticalContainter/PCEOMONES/Stamina.value = (increasing_value%50)*2
	$TutorialsAndText/Tutorial/Combat/VerticalContainter/PCEOMONES/Alcohol.value = (increasing_value%25)*4
func _on_Exit_pressed():
	get_tree().change_scene("res://Title/TitleScreen.tscn")


func _on_Combat_pressed():
	current.visible = false
	current = $TutorialsAndText/Tutorial/Combat
	current.visible = true

	
