extends VBoxContainer


signal pressed()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_button(pceomon:String, major:bool):
	var texture_pceomon
	var texture_pceomon_byn
	var nombre_real = pceomon
	if pceomon == "MarineraDeCantor":
		nombre_real = "Marinera de Cantor"
	if pceomon == "CafeteraComunista":
		nombre_real = "Cafetera Comunista"
	if pceomon == "FuncionDeWeierstrass":
		nombre_real = "Función de Weierstrass"
	if major:
		texture_pceomon = load("res://Sprites/PCEOMONES/Major/" + pceomon + "/" + pceomon +"_avatar.png")
		texture_pceomon_byn = load("res://Sprites/PCEOMONES/Major/" + pceomon + "/" + pceomon +"_avatar_seleccionado.png")
	else:
		texture_pceomon = load("res://Sprites/PCEOMONES/Minor/" + pceomon + "/" + pceomon +"_avatar.png")
		texture_pceomon_byn = load("res://Sprites/PCEOMONES/Minor/" + pceomon + "/" + pceomon +"_avatar_seleccionado.png")
	if !(nombre_real in metadata.party):
		$Sprite.texture_normal = texture_pceomon
		$Sprite.texture_pressed = texture_pceomon
		$Sprite.texture_focused = texture_pceomon
		$Sprite.texture_hover = texture_pceomon
		$Sprite.texture_disabled = texture_pceomon
	else:
		$Sprite.texture_normal = texture_pceomon_byn
		$Sprite.texture_pressed = texture_pceomon_byn
		$Sprite.texture_focused = texture_pceomon_byn
		$Sprite.texture_hover = texture_pceomon_byn
		$Sprite.texture_disabled = texture_pceomon_byn


func _on_Sprite_pressed():
	emit_signal("pressed")
