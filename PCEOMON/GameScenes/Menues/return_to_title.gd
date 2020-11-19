extends Control
#Cargamos los sprites de los PCEOMONES

func _ready():
	# $Music.volume_db = metadata.volumevalue
	$"/root/MainScreenMusicController".play_loop("res://OST/IntroAndMenu/character_selection_screen.ogg", true)
	$CenterContainer/MenuDistribution/Miscelaneous/Party.text = "Equipo: "
	for pceomon in metadata.party:
		$CenterContainer/MenuDistribution/Miscelaneous/Party.text = $CenterContainer/MenuDistribution/Miscelaneous/Party.text + ' ' + pceomon


# Añade el pceomon a la party si no está y lo elimina si está
func manage_party(pceomon):
	var minor = false
	if $PCEOMONInfo/VBoxGlobal/Miscelaneus/Type.text == "Menor":
		minor = true
	if not (pceomon in metadata.party):
		metadata.party.append(pceomon)
		if not minor:
			metadata.party_paths.append("res://Sprites/PCEOMONES/Major/" + pceomon + "/" + pceomon +".tscn")
		else:
			metadata.party_paths.append("res://Sprites/PCEOMONES/Minor/" + pceomon + "/" + pceomon +".tscn")
		var text = $"CenterContainer/MenuDistribution/Miscelaneous/Party".text
		text = text + ' ' + pceomon
		$"CenterContainer/MenuDistribution/Miscelaneous/Party".text = text
	else:
		metadata.party.erase(pceomon)
		if not minor:
			metadata.party_paths.erase("res://Sprites/PCEOMONES/Major/" + pceomon + "/" + pceomon +".tscn")
		else:
			metadata.party_paths.erase("res://Sprites/PCEOMONES/Minor/" + pceomon + "/" + pceomon +".tscn")
		var text = $"CenterContainer/MenuDistribution/Miscelaneous/Party".text	
		text = text.replace(' ' + pceomon,"")
		$"CenterContainer/MenuDistribution/Miscelaneous/Party".text = text
	
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
func getAndSetInfo(pceomon:String):
	var texture = load("res://Sprites/PCEOMONES/Major/" + pceomon + "/" + pceomon + "_avatar.png")
	var file = File.new()
	file.open("res://GameScenes/Menues/Selection/PCEOMONES/Major/" + pceomon +"Info.txt", File.READ)
	var name = file.get_line().replace("\\n","\n")
	var description = file.get_line().replace("\\n","\n")
	var type = file.get_line().replace("\\n","\n")
	var abilityname = file.get_line().replace("\\n","\n")
	var abilityminidesc = file.get_line().replace("\\n","\n")
	var abilitydesc = file.get_line().replace("\\n","\n")
	var att1name = file.get_line().replace("\\n","\n")
	var att1minidesc = file.get_line().replace("\\n","\n")
	var att1desc = file.get_line().replace("\\n","\n")
	var att2name = file.get_line().replace("\\n","\n")
	var att2minidesc = file.get_line().replace("\\n","\n")
	var att2desc = file.get_line().replace("\\n","\n")
	var att3name = file.get_line().replace("\\n","\n")
	var att3minidesc = file.get_line().replace("\\n","\n")
	var att3desc = file.get_line().replace("\\n","\n")
	var att4name = file.get_line().replace("\\n","\n")
	var att4minidesc = file.get_line().replace("\\n","\n")
	var att4desc = file.get_line().replace("\\n","\n")
	file.close()
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text = name
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Sprite".texture = texture
	$"PCEOMONInfo/VBoxGlobal/MainInfo/Descripcion".text = description
	$"PCEOMONInfo/VBoxGlobal/Miscelaneus/Type".text = type
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Ability/AbName".text = abilityname
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack1/At1Name".text = att1name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack2/At2Name".text = att2name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack3/At3Name".text = att3name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack4/At4Name".text = att4name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Ability/AbDesc".text = abilityminidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack1/At1Desc".text = att1minidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack2/At2Desc".text = att2minidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack3/At3Desc".text = att3minidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack4/At4Desc".text = att4minidesc
	$"PCEOMONInfo".AbDesc = abilitydesc
	$"PCEOMONInfo".At1Desc = att1desc
	$"PCEOMONInfo".At2Desc = att2desc
	$"PCEOMONInfo".At3Desc = att3desc
	$"PCEOMONInfo".At4Desc = att4desc
	$"PCEOMONInfo/RequestedData/SpriteName/Sprite".texture = texture
	change_select_button(name.replace(" ", ""))
	#Puede parecer que en las siguientes lineas hay un mareo increíble, pero de esta forma
	#se soluciona un bug que hace que el texto no se centre (ni ide de por qué)
	$"CenterContainer".visible = false
	$"PCEOMONInfo".visible = true
	$"PCEOMONInfo/VBoxGlobal".visible = true
	$"PCEOMONInfo/RequestedData".visible = false
	$"CenterContainer".visible = true
	$"PCEOMONInfo".visible = false
	$"CenterContainer".visible = false
	$"PCEOMONInfo".visible = true
	#setPCEOMONinfo(name, texture, description, type, ability, att1, att2, att3, att4)

func getAndSetInfoMinor(pceomon: String):
	var texture = load("res://Sprites/PCEOMONES/Minor/" + pceomon + "/" + pceomon + "_avatar.png")
	var file = File.new()
	file.open("res://GameScenes/Menues/Selection/PCEOMONES/Minor/" + pceomon +"Info.txt", File.READ)
	var name = file.get_line().replace("\\n","\n")
	var description = file.get_line().replace("\\n","\n")
	var type = file.get_line().replace("\\n","\n")
	var abilityname = file.get_line().replace("\\n","\n")
	var abilityminidesc = file.get_line().replace("\\n","\n")
	var abilitydesc = file.get_line().replace("\\n","\n")
	var att1name = file.get_line().replace("\\n","\n")
	var att1minidesc = file.get_line().replace("\\n","\n")
	var att1desc = file.get_line().replace("\\n","\n")
	var att2name = file.get_line().replace("\\n","\n")
	var att2minidesc = file.get_line().replace("\\n","\n")
	var att2desc = file.get_line().replace("\\n","\n")
	var att3name = file.get_line().replace("\\n","\n")
	var att3minidesc = file.get_line().replace("\\n","\n")
	var att3desc = file.get_line().replace("\\n","\n")
	var att4name = file.get_line().replace("\\n","\n")
	var att4minidesc = file.get_line().replace("\\n","\n")
	var att4desc = file.get_line().replace("\\n","\n")
	file.close()
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text = name
	$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Sprite".texture = texture
	$"PCEOMONInfo/VBoxGlobal/MainInfo/Descripcion".text = description
	$"PCEOMONInfo/VBoxGlobal/Miscelaneus/Type".text = type
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Ability/AbName".text = abilityname
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack1/At1Name".text = att1name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack2/At2Name".text = att2name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack3/At3Name".text = att3name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack4/At4Name".text = att4name
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Ability/AbDesc".text = abilityminidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack1/At1Desc".text = att1minidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack2/At2Desc".text = att2minidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack3/At3Desc".text = att3minidesc
	$"PCEOMONInfo/VBoxGlobal/AbilityAttacks/Attack4/At4Desc".text = att4minidesc
	$"PCEOMONInfo".AbDesc = abilitydesc
	$"PCEOMONInfo".At1Desc = att1desc
	$"PCEOMONInfo".At2Desc = att2desc
	$"PCEOMONInfo".At3Desc = att3desc
	$"PCEOMONInfo".At4Desc = att4desc
	$"PCEOMONInfo/RequestedData/SpriteName/Sprite".texture = texture
	change_select_button(name.replace(" ", ""))
	#Puede parecer que en las siguientes lineas hay un mareo increíble, pero de esta forma
	#se soluciona un bug que hace que el texto no se centre (ni ide de por qué)
	$"CenterContainer".visible = false
	$"PCEOMONInfo".visible = true
	$"PCEOMONInfo/VBoxGlobal".visible = true
	$"PCEOMONInfo/RequestedData".visible = false
	$"CenterContainer".visible = true
	$"PCEOMONInfo".visible = false
	$"CenterContainer".visible = false
	$"PCEOMONInfo".visible = true


func _on_Armada_pressed():
	getAndSetInfo("Armada")


func _on_Alparko_pressed():
	getAndSetInfo("Alparko")
	#$"CenterContainer".visible = false
	#$"PCEOMONInfo".visible = true
	#$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text = "Alparko"
	#$"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Sprite".texture = AlparkoS
	#change_select_button("Alparko")
	
	

func _on_FuncionDeWeierstrass_pressed():
	getAndSetInfoMinor("FuncionDeWeierstrass")

func _on_PCEOMONInfo_volver():
	$"CenterContainer".visible = true
	$"PCEOMONInfo".visible = false

#Funcion que cambia el sprite del PCEOMON seleccionado a blanco y negro o a color si se deselecciona
func change_PCEOMON_button(pceomon):
	if !($PCEOMONInfo/VBoxGlobal/Miscelaneus/Type.text == "Menor"):
		if pceomon == "Armada":
			$"CenterContainer/MenuDistribution/Major/SelectAndNavigate/Column1/Armada".change_button(pceomon,true)
		elif pceomon == "Alparko":
			$"CenterContainer/MenuDistribution/Major/SelectAndNavigate/Column2/Alparko".change_button(pceomon,true)
		elif pceomon == "Chito":
			$"CenterContainer/MenuDistribution/Major/SelectAndNavigate/Column3/Chito".change_button(pceomon,true)
	else:
		if pceomon == "CafeteraComunista":
			$"CenterContainer/MenuDistribution/Minor/Minors/CafeteraComunista".change_button("CafeteraComunista",false)
		if pceomon == "Teclado":
			$"CenterContainer/MenuDistribution/Minor/Minors/Teclado".change_button("Teclado",false)
		if pceomon == "FuncióndeWeierstrass":
			$"CenterContainer/MenuDistribution/Minor/Minors/FuncionDeWeierstrass".change_button("FuncionDeWeierstrass",false)
		if pceomon == "MarineraDeCantor":
			$"CenterContainer/MenuDistribution/Minor/Minors/MarineraDeCantor".change_button("MarineraDeCantor",false)


func _on_PCEOMONInfo_seleccionar():
	if ((metadata.party.size() < 5) or ($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text.replace(" ","") in metadata.party)):
		manage_party($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text.replace(" ",""))
		change_select_button($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text.replace(" ",""))
		change_PCEOMON_button($"PCEOMONInfo/VBoxGlobal/MainInfo/SpriteName/Name".text.replace(" ",""))
		_on_PCEOMONInfo_volver()




func _on_MarineraDeCantor_pressed():
	getAndSetInfoMinor("MarineraDeCantor")


func _on_CafeteraComunista_pressed():
	getAndSetInfoMinor("CafeteraComunista")


func _on_Teclado_pressed():
	getAndSetInfoMinor("Teclado")


func _on_Chito_pressed():
	getAndSetInfo("Chito")


func _on_Paco_pressed():
	pass # Replace with function body.
