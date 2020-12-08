extends Control

signal itemDescription(mostrar, description)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setTexture(texture):
	$"Texture&Name/Texture".texture = texture
	
func setName(nombre):
	$"Texture&Name/Name".text = nombre
	
func setDescription(descripcion):
	$Description.text = descripcion
	

func _on_TextureName_mouse_entered():
	emit_signal("itemDescription", true, $Description.text)

func _on_TextureName_mouse_exited():
	emit_signal("itemDescription", false, $Description.text)
