extends Area2D

signal sprite_pressed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpriteContainer_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and not (event.pressed):
		emit_signal("sprite_pressed")
