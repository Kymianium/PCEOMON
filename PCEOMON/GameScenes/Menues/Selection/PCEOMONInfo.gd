extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal volver
signal seleccionar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Volver_pressed():
	emit_signal("volver")


func _on_Seleccionar_pressed():
	emit_signal("seleccionar")
