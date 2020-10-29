extends Control
#Cargamos los sprites de los PCEOMONES
var armadaS = preload("res://Sprites/PCEOMONES/Major/Armada/Armada_avatar.png")
var alparkoS = preload("res://Sprites/PCEOMONES/Major/Alparko/Alparko_avatar.png")

var paths = { "Armada" : "res://Sprites/PCEOMONES/Major/Armada/Armada.tscn",
"Alparko" : "res://Sprites/PCEOMONES/Major/Alparko/Alparko.tscn" }

# Añade el pceomon a la party si no está y lo elimina si está
func manage_party(pceomon):
	if (metadata.party.size() < 5):
		if not (pceomon in metadata.party):
			metadata.party.append(pceomon)
			metadata.party_paths.append(paths[pceomon])
			var text = $"CenterContainer/MenuDistribution/Miscelaneous/Party".text
			text = text + ' ' + pceomon
			$"CenterContainer/MenuDistribution/Miscelaneous/Party".text = text
		else:
			metadata.party.erase(pceomon)
			metadata.party_paths.erase(paths[pceomon])
			var text = $"CenterContainer/MenuDistribution/Miscelaneous/Party".text	
			text = text.replace(' ' + pceomon,"")
			$"CenterContainer/MenuDistribution/Miscelaneous/Party".text = text
	print(metadata.party, metadata.party_paths)
	
func change_select_button(pceomon):
	if pceomon in metadata.party:
		$"PCEOMONInfo/VBoxGlobal/Control/Seleccionar".text = "Quitar"
	else:
		$"PCEOMONInfo/VBoxGlobal/Control/Seleccionar".text = "Seleccionar"

func _on_Button_pressed():
	get_tree().change_scene("res://Title/TitleScreen.tscn")


func _on_Start_pressed():
	get_tree().change_scene("res://GameScenes/CombatScenes/CombatTemporary.tscn")


func setPCEOMONinfo(name : String, texture, description : String,
 type : String, ability : String, att1 : String, att2 : String, att3 : String, att4 : String):
	$"CenterContainer".visible = false
	$"PCEOMONInfo".visible = true
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text = name
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Sprite".texture = texture
	$"PCEOMONInfo/VBoxGlobal/MainInfo/Descripcion".text = description
	$"PCEOMONInfo/VBoxGlobal/Miscelaneus/Type".text = type
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Ability".text = ability
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack1".text = att1
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack2".text = att2
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack3".text = att3
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack4".text = att4
	change_select_button(name)


func _on_Armada_pressed():
	setPCEOMONinfo("Armada", armadaS, "Una auténtica leyenda del PCEO, víctima de una \ngrave adicción a las bebidas alcohólicas y a Bad Bunny.\n @alvaritoarmada en instagram", "Alcohólico",
	"Rapunzel - Gana un escudo de manera pasiva",
	"Postureo - Daño químico y baja la precisión de los enemigos.", 
	"El Quijote - Un caballero hidalgo. Aturde y envenena a un enemigo.", 
	"Esto no es na - Recupera alcohol en sangre y hace daño químico.", 
	"¿Un lolete? - Dispara proyectiles y dinamita a todos los enemigos.")


func _on_Alparko_pressed():
	setPCEOMONinfo("Alparko", alparkoS,"Un capo. Liberal en lo económico. \n Seguidlo en twitter: @putogordo69", "Programador" ,
	"Peaceful mode - No puede ser atacado hasta no atacar", "/tp - Redirige el daño de un ataque", 
	"Aspecto ígneo - Incrementa daño del siguiente ataque de un\n PCEOMON", 
	"/timeset day - Elimina criaturas pasivas",
	 "/weather clear - Devuelve los stats a su estado original")
	$"CenterContainer".visible = false
	$"PCEOMONInfo".visible = true
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text = "Alparko"
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Sprite".texture = alparkoS
	change_select_button("Alparko")
	
	



func _on_PCEOMONInfo_volver():
	$"CenterContainer".visible = true
	$"PCEOMONInfo".visible = false


func _on_PCEOMONInfo_seleccionar():
	manage_party($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text)
	change_select_button($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text)
