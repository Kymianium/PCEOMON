extends Control
#Cargamos los sprites de los PCEOMONES
var ArmadaS = preload("res://Sprites/PCEOMONES/Major/Armada/Armada_avatar.png")
var AlparkoS = preload("res://Sprites/PCEOMONES/Major/Alparko/Alparko_avatar.png")
var WeierstrassS = preload("res://Sprites/PCEOMONES/Minor/FuncionDeWeierstrass/FuncionDeWeierstrass_avatar.png")
var CafeteraS = preload("res://Sprites/PCEOMONES/Minor/CafeteraComunista/CafeteraComunista_avatar.png")
var MarineraDeCantorS = preload("res://Sprites/PCEOMONES/Minor/MarineraDeCantor/MarineraDeCantor_avatar.png")
var TecladoS = preload("res://Sprites/PCEOMONES/Minor/Teclado/Teclado_avatar.png")

var paths = { "Armada" : "res://Sprites/PCEOMONES/Major/Armada/Armada.tscn",
"Alparko" : "res://Sprites/PCEOMONES/Major/Alparko/Alparko.tscn" ,
"Cafetera Comunista" : "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CafeteraComunista.tscn"}


func _ready():
	# $Music.volume_db = metadata.volumevalue
	$"/root/MainScreenMusicController".play_loop("res://OST/IntroAndMenu/character_selection_screen.ogg", true)
	$CenterContainer/MenuDistribution/Miscelaneous/Party.text = "Equipo: "
	for pceomon in metadata.party:
		$CenterContainer/MenuDistribution/Miscelaneous/Party.text = $CenterContainer/MenuDistribution/Miscelaneous/Party.text + ' ' + pceomon


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
	$"/root/MainScreenMusicController".play_loop("", false)


func _on_Start_pressed():
	if (metadata.party.size()>0):
		get_tree().change_scene("res://GameScenes/CombatScenes/CombatTemporary.tscn")
		$"/root/MainScreenMusicController".play_loop("", false)
	else:
		pass	#PONER ALGÚN MENSJE ROLLO "NO HAS ELEGIDO PCEOMONES"


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

#######################################################################################
######PARA VER LA ESTRRUCTURA QUE SIGUE EL TXT COMPROBAR EL ARCHIVO ModelInfo.tres######
#######################################################################################
func getAndSetInfo(pceomon:String, texture):
	var file = File.new()
	file.open("res://GameScenes/Menues/Selection/PCEOMONES/Major/" + pceomon +"Info.tres", File.READ)
	print("Leyendo " + pceomon)
	var name = file.get_line().replace("\\n","\n")
	var description = file.get_line().replace("\\n","\n")
	var type = file.get_line().replace("\\n","\n")
	var ability = file.get_line().replace("\\n","\n")
	var att1 = file.get_line().replace("\\n","\n")
	var att2 = file.get_line().replace("\\n","\n")
	var att3 = file.get_line().replace("\\n","\n")
	var att4 = file.get_line().replace("\\n","\n")
	file.close()
	setPCEOMONinfo(name, texture, description, type, ability, att1, att2, att3, att4)

func getAndSetInfoMinor(pceomon: String, texture):
	var file = File.new()
	file.open("res://GameScenes/Menues/Selection/PCEOMONES/Minor/" + pceomon +"Info.tres", File.READ)
	print("Leyendo " + pceomon)
	var name = file.get_line().replace("\\n","\n")
	var description = file.get_line().replace("\\n","\n")
	var type = file.get_line().replace("\\n","\n")
	var ability = file.get_line().replace("\\n","\n")
	var att1 = file.get_line().replace("\\n","\n")
	var att2 = file.get_line().replace("\\n","\n")
	var att3 = file.get_line().replace("\\n","\n")
	var att4 = file.get_line().replace("\\n","\n")
	file.close()
	setPCEOMONinfo(name, texture, description, type, ability, att1, att2, att3, att4)

func _on_Armada_pressed():
	getAndSetInfo("Armada",ArmadaS)


func _on_Alparko_pressed():
	getAndSetInfo("Alparko",AlparkoS)
	#$"CenterContainer".visible = false
	#$"PCEOMONInfo".visible = true
	#$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text = "Alparko"
	#$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Sprite".texture = AlparkoS
	#change_select_button("Alparko")
	
	

func _on_FuncionDeWeierstrass_pressed():
	getAndSetInfoMinor("FuncionDeWeierstrass", WeierstrassS)

func _on_PCEOMONInfo_volver():
	$"CenterContainer".visible = true
	$"PCEOMONInfo".visible = false


func _on_PCEOMONInfo_seleccionar():
	manage_party($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text)
	change_select_button($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text)





func _on_MarineraDeCantor_pressed():
	getAndSetInfoMinor("MarineraDeCantor", MarineraDeCantorS)


func _on_CafeteraComunista_pressed():
	getAndSetInfoMinor("CafeteraComunista",CafeteraS)
