extends CenterContainer

signal input

var characters : int = 0
var deltacum : float = 0
var drawspeed : float = 0.02
var permanent_dialog : bool = false

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_ENTER) or (event is InputEventMouseButton and event.button_index == 1 and not (permanent_dialog) and not (event.pressed)):
		emit_signal("input")

func set_permanent_dialog(value : bool):
	permanent_dialog = value
	


func message(message : String):
	$Background/Text.set_bbcode(message)
	$Background/Text.visible_characters = 0
func _ready():
	$Background/Text.visible_characters = 0
	$Background/Text.rect_clip_content = false
func _process(delta):
	if ($Background/Text.text.length() > $Background/Text.visible_characters):
		deltacum+=delta
		if deltacum > drawspeed:
			$Background/Text.visible_characters+=1
			deltacum-=drawspeed
