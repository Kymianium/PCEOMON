extends Control

export var description:String

signal itemDescription(name, description)
signal announcement(message)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setTexture(texture):
	$"Texture&Name/Texture".texture = texture
	
func setName(nombre):
	$"Texture&Name/Name".text = nombre
	
	

func _on_TextureName_mouse_entered():
	#emit_signal("itemDescription", true, $"Texture&Name/Name".text)
	pass

func _on_TextureName_mouse_exited():
	#emit_signal("itemDescription", false, $"Texture&Name/Name".text)
	pass

func useObject(target):
	pass

func _on_Button_pressed():
	emit_signal("itemDescription", $"Texture&Name/Name".text, description)
