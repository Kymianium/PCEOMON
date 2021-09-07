extends Node2D

var adjusted_interface = 0

var pceomon

var pceo_instance

var avatar : TextureRect

var avatars = {}

var info : String

var R4 = {}

var rng = RandomNumberGenerator.new()


var can_attack:bool = true #la primera semana de PCD me dice que eso no deberia de ir, pero estoy desperado

signal can_attack_unlocked()

signal pceomon_pressed(pceomon,boss)

signal ended_text


#Si pulsamos la tecla escape, se cerrará la partida
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _ready():
	#Al comienzo del combate, todos los PCEOMONES están en la dimensión por defecto
	metadata.dimensions["default"] = []
	
	#Utilizaremos esta conexión para que se conecte el cuadro de diálogo
	$Combatinterface.connect("text", self, "incoming_announcement")
	
	
	
	#Instanciamos los PCEOMONES que están almancenados en metadata.party
	for i in range(0, metadata.party.size()):
		pceomon = load(metadata.party_paths[i])
		pceo_instance = pceomon.instance()
		pceo_instance.position.x = metadata.combat_position[i][0]
		pceo_instance.position.y = metadata.combat_position[i][1]
		metadata.dimensions["default"].append(pceo_instance)
		$Party.add_child(pceo_instance)
		
		##
		##	SEÑALES IMPLEMENTADAS
		##
		#Para cuando has atacado y quieres escribir el texto del ataque
		pceo_instance.connect("just_attacked", self, "write_attack_text")
		#Para cuando palmas
		pceo_instance.connect("died", self, "pceomon_died")
		#Para cuando hay que anunciar algo
		pceo_instance.connect("announcement", self, "incoming_announcement")
		#Para cuando hay que anunciar algo y no quieres que se vaya fácilmente
		pceo_instance.connect("permanent_announcement",self,"incoming_permanent_announcement")
		#Para cuando pulsas sobre un PCEOMÓN
		pceo_instance.connect("sprite_pressed",self,"pceomon_pressed")
		#Cuando seleccionas un adversario, desaparece el cartel de "Selecciona un adversario"
		pceo_instance.connect("target_selected",self,"_on_DialogueBox_input")
		#Se le pasan los parámetros donde hay que dibujar y dibuja una partícula
		pceo_instance.connect("particle", self, "draw_particle")
		#Te hace una paja (tú qué crees?)
		pceo_instance.connect("revive",self,"revive")
		#Para hacer zoom a un PCEOMON cuando hace un ataque
		pceo_instance.connect("camera_zoom",$Camera2D,"zoom_PCEOMON")
		#Cuando presionas un PCEOMÓN, la instancia recibe la señal
		self.connect("pceomon_pressed",pceo_instance,"target_selected")
		
		
		#Si es un R4, entonces se crea "su dimensión"
		if (pceo_instance.type == "R4"):
			metadata.dimensions[pceo_instance.name] = [pceo_instance]
			pceo_instance.connect("dimension_changed",self,"adjust_dimension")
			pceo_instance.connect("release_pceomon",self,"release_pceomon")
			
		
		#Algunas cosas misceláneas de los PCEOMONES
		pceo_instance.manager = self
		avatar = TextureRect.new()
		avatar.texture = load(pceo_instance.avatar_path)
		avatars[pceo_instance]=avatar
	
	#Lo mismo para los enemigos
	
	################
	### IMPORTANTE #    Hay un array en metadata que se llama enemy_party, cambiar esto para que se inicialice desde ahí
	################
	
	for j in range(0, metadata.enemy_party_path.size()):
		pceomon = load(metadata.enemy_party_path[j])
		pceo_instance = pceomon.instance()
		pceo_instance.position.x = 540 - metadata.combat_position[j][0]
		pceo_instance.position.y = metadata.combat_position[j][1]
		metadata.dimensions["default"].append(pceo_instance)
		$Enemies.add_child(pceo_instance)
		pceo_instance.connect("sprite_pressed",self,"pceomon_pressed")
		pceo_instance.connect("just_attacked", self, "write_attack_text")
		pceo_instance.connect("died", self, "pceomon_died")
		pceo_instance.connect("announcement", self, "incoming_announcement")
		pceo_instance.connect("permanent_announcement",self,"incoming_permanent_announcement")
		pceo_instance.connect("target_selected",self,"_on_DialogueBox_input")
		pceo_instance.connect("particle", self, "draw_particle")
		pceo_instance.connect("revive",self,"revive")
		self.connect("pceomon_pressed",pceo_instance,"target_selected")
		
		
	#Inicia los arrays de compañeros y adversarios
	load_pceomones()
	
	
	self.connect("pceomon_pressed",$Combatinterface/ObjectMenu,"target_selected")
	$Combatinterface/ObjectMenu.connect("announcement", self, "incoming_announcement")
	$Combatinterface/ObjectManager.connect("announcement",self,"incoming_announcement")
	
	#Iniciamos los gyms y todos los que necesiten seleccionar
	for pceo in $"Party".get_children():
		if (pceo.need_to_select):
			pceo.needed_select()

#Escribe el texto asociado a los ataques
func write_attack_text(user: String, attack : String, objective : String, string : String):
	if $Combatinterface/DialogueBox.visible == true:
		yield(self,"ended_text")
		
	var showmessage
	metadata.freeze_time = true
	$Combatinterface/DialogueBox.visible = true
	if(objective == ""):
		showmessage = "¡" + user + " usó " + attack + "! " + string
	else:
		showmessage = "¡" + user + " usó " + attack + " sobre " + objective + "! " + string
	make_interface_visible(false)
	$Combatinterface/DialogueBox.message(showmessage)




#Incializa los arrays de compañeros y enemigos
func load_pceomones():
	for enemy in $"Enemies".get_children():
		enemy.foes = []
		enemy.mates = []
		for enemy2 in $"Enemies".get_children():
			if enemy2 != enemy:
				enemy.new_mate(enemy2)
	for mate in $"Party".get_children():
		mate.foes = []
		for enemy in $"Enemies".get_children():
			mate.new_foe(enemy)
			enemy.new_foe(mate)
		for mate2 in $"Party".get_children():
			if mate != mate2:
				mate.new_mate(mate2)

#Cuando es el turno de un PCEOMÓN, se cambia la interfaz para mostrar sus ataques.
func change_interface(turner): #TODO hacer que esto no atente contra los derechos humanos (siempre abre ficheros de texto, almacenar esa info en los PCEOMONES)
	$Combatinterface/CombatGUI/Fight/Avatar.texture = load(turner.avatar_path)
#	var txt = File.new()
#	if turner.type != "Menor":
#		txt.open("res://GameScenes/Menues/Selection/PCEOMONES/Major/" + turner.name.replace(" ","") +"Info.txt", File.READ)
#	else:
#		txt.open("res://GameScenes/Menues/Selection/PCEOMONES/Minor/" + turner.name.replace(" ","") +"Info.txt", File.READ)
#	txt.get_line().replace("\\n","\n")
#	txt.get_line().replace("\\n","\n")
#	txt.get_line().replace("\\n","\n")
#	var abilityname = txt.get_line().replace("\\n","\n")
#	txt.get_line().replace("\\n","\n")
#	var abilitydesc = txt.get_line().replace("\\n","\n")
#	var att1name = txt.get_line().replace("\\n","\n")
#	txt.get_line().replace("\\n","\n")
#	var att1desc = txt.get_line().replace("\\n","\n")
#	var att2name = txt.get_line().replace("\\n","\n")
#	txt.get_line().replace("\\n","\n")
#	var att2desc = txt.get_line().replace("\\n","\n")
#	var att3name = txt.get_line().replace("\\n","\n")
#	txt.get_line().replace("\\n","\n")
#	var att3desc = txt.get_line().replace("\\n","\n")
#	var att4name = txt.get_line().replace("\\n","\n")
#	txt.get_line().replace("\\n","\n")
#	var att4desc = txt.get_line().replace("\\n","\n")
	
	$Combatinterface/CombatGUI/Data/Attacks1/Atk1.text = turner.att1name
	$Combatinterface/CombatGUI/Data/Attacks1/Atk2.text = turner.att2name
	$Combatinterface/CombatGUI/Data/Attacks2/Atk3.text = turner.att3name
	$Combatinterface/CombatGUI/Data/Attacks2/Atk4.text = turner.att4name
	$Combatinterface/CombatGUI/Data/Passive/Passive.text = turner.abilityname
	$Combatinterface.atk1 = turner.att1desc
	$Combatinterface.atk2 = turner.att2desc
	$Combatinterface.atk3 = turner.att3desc
	$Combatinterface.atk4 = turner.att4desc
	$Combatinterface.passive = turner.abilitydesc
	
	#Metainformación (vida)
	info = str(turner.name) + "\n" + 'VIDA : ' + str(turner.actual_hp) + '/' + str(turner.max_hp)
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack1".text = turner.att1name
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack2".text = turner.att2name
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack3".text = turner.att3name
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack4".text = turner.att4name
	$"Combatinterface/CombatGUI/MainOptions/Info".text = info


func make_interface_visible(visible : bool):
	$"Combatinterface/CombatGUI".visible = visible

#Cambia de dimensión a los PCEOMONES
func adjust_dimension(dimension, pceomon): #TODO por qué cojones la primera linea es la que es
	if pceomon.name == "Azul42" and rng.randf() < 0.5:
		return
	#TODO almacenar el avatar de los R4 antes (en el ready)
	var avatar = load("res://Sprites/PCEOMONES/Major/" + dimension.name + "/" + dimension.name + "_avatar.png")
	var icon = Sprite.new()
	add_child(icon)
	icon.texture = avatar
	icon.position.x = pceomon.position.x + pceomon.get_size().x/2
	icon.position.y = pceomon.position.y + pceomon.get_size().y
	icon.modulate.a8 = 200
	icon.scale.x = 0.5
	icon.scale.y = 0.5
	# Fin del ready 
	
	
	#Reajustamos los arrays de mates y foes para no poder seleccionar pceomones de distinta dimension
	R4[pceomon] = icon
	pceomon.foes = []
	pceomon.mates = []
	metadata.dimensions["default"].erase(pceomon)
	for pceomones in metadata.dimensions["default"]:
		if pceomon in pceomones.mates:
			pceomones.mates.erase(pceomon)
		elif pceomon in pceomones.foes:
			pceomones.foes.erase(pceomon)
	if pceomon in $Party.get_children():
		for pceomones in metadata.dimensions[dimension.name]:
			if pceomones in $Party.get_children():
				pceomon.mates.append(pceomones)
				pceomones.mates.append(pceomon)
			else:
				pceomon.foes.append(pceomones)
				pceomones.foes.append(pceomon)
	else:
		for pceomones in metadata.dimensions[dimension.name]:
			if pceomones in $Enemies.get_children():
				pceomon.mates.append(pceomones)
				pceomones.mates.append(pceomon)
			else:
				pceomon.foes.append(pceomones)
				pceomones.foes.append(pceomon)
	metadata.dimensions[dimension.name].append(pceomon)
	check_targets(pceomon, dimension)		#Si estamos atacando a alguien y desaparece hay que dejar de atacar (junto con otros casos especiales)

#análogo a la funcion anterior
func release_pceomon(dimension, pceomon):
	pceomon.foes = []
	pceomon.mates = []
	if pceomon in metadata.dimensions[dimension.name]:
		metadata.dimensions[dimension.name].erase(pceomon)
		for pceomones in metadata.dimensions[dimension.name]:
			if pceomon in pceomones.mates:
				pceomones.mates.erase(pceomon)
			elif pceomon in pceomones.foes:
				pceomones.foes.erase(pceomon)
		if pceomon in $Party.get_children():
			for pceomones in metadata.dimensions["default"]:
				if pceomones in $Party.get_children():
					pceomon.mates.append(pceomones)
					pceomones.mates.append(pceomon)
				else:
					pceomon.foes.append(pceomones)
					pceomones.foes.append(pceomon)
		else:
			for pceomones in metadata.dimensions["default"]:
				if pceomones in $Enemies.get_children():
					pceomon.mates.append(pceomones)
					pceomones.mates.append(pceomon)
				else:
					pceomon.foes.append(pceomones)
					pceomones.foes.append(pceomon)
		metadata.dimensions["default"].append(pceomon)
		check_targets(pceomon, dimension)
		R4[pceomon].queue_free()
		R4.erase(pceomon)

#Para dejar de atacar si un pceomon cambia de dimension etc.
#TODO: implementar esto en PCEOMON_combat para poder hacer casos especiales allí
func check_targets(PCEOMON, R4):
	for pceo in $Party.get_children():
		if pceo==R4:
			continue
		if (PCEOMON in pceo.targets):
			pceo.target_gone(PCEOMON)
		if (PCEOMON == pceo):
			for target in pceo.targets:
				pceo.target_gone(target)
			if (pceo.type == "Gym"):
				pceo.focus_enemy()
		if (pceo.type == "Gym" and pceo.selected_foe == PCEOMON):
			pceo.focus_enemy()
		if (pceo.type == "Gym" and pceo.selected_foe == null and PCEOMON in pceo.foes):
			pceo.selected_foe = PCEOMON
	for pceo in $Enemies.get_children():
		if PCEOMON in pceo.targets:
			PCEOMON.actual_stamina = 0
		if (pceo.type == "Gym" and pceo.selected_foe == null and PCEOMON in pceo.foes):
			pceo.selected_foe = PCEOMON


#Las siguientes funciones se llaman al pulsar los botones de ataque o cuando se selecciona un objeto

func _on_Attack1_pressed():	
	if (metadata.time_exists.size() != 0):
		metadata.time_exists[metadata.time_exists.size()-1].next1()
		adjusted_interface = metadata.time_exists.size() #TODO: no se que narices es esto


func _on_Attack2_pressed():
	if (metadata.time_exists.size() != 0):
		metadata.time_exists[metadata.time_exists.size()-1].next2()
		adjusted_interface = metadata.time_exists.size()


func _on_Attack_3_pressed():
	if (metadata.time_exists.size() != 0):
		metadata.time_exists[metadata.time_exists.size()-1].next3()
		adjusted_interface = metadata.time_exists.size()

func _on_Attack4_pressed():
	if (metadata.time_exists.size() != 0):
		metadata.time_exists[metadata.time_exists.size()-1].next4()
		adjusted_interface = metadata.time_exists.size()


func _on_ObjectMenu_object_selected(selected,pceomon):
	if (metadata.time_exists.size() != 0):
		var ref = $ObjectMenu.get_func_from_name(selected)
		metadata.time_exists[metadata.time_exists.size()-1].nextobject(ref,pceomon)
		adjusted_interface = metadata.time_exists.size()


func _process(_delta):
	if (metadata.time_exists.size() != 0 ):
		make_interface_visible(true)
		change_interface(metadata.time_exists[metadata.time_exists.size()-1])
		if adjusted_interface != metadata.time_exists.size(): 
			adjusted_interface = metadata.time_exists.size()
	else:
		make_interface_visible(false)

#Conectado a la señal died, elimina el PCEOMON de las listas de PCEOMONES mates y foes.
func pceomon_died(pceomon):
	incoming_announcement("¡" + pceomon.name + " se ha debilitado!")
	if pceomon.boss:
		for mate in $"Party".get_children():
			mate.foes.erase(pceomon)
		for enemy in $"Enemies".get_children():
			enemy.mates.erase(pceomon)
	else:
		
		avatars[pceomon].visible = false
		for mate in $"Party".get_children():
			mate.mates.erase(pceomon)
		for enemy in $"Enemies".get_children():
			enemy.foes.erase(pceomon)
			print(pceomon.name , " eliminado de la lista de ", enemy.name)

#siempre se emite una señal cuando se pulsa a un PCEOMON. Si es necesario, el pceomon seleccionando objetivo recibirña esta señal
func pceomon_pressed(pceomon,boss):
	emit_signal("pceomon_pressed",pceomon,boss)


func incoming_permanent_announcement(announce):
	$Combatinterface/DialogueBox.set_permanent_dialog(true)
	incoming_announcement(announce)

func incoming_announcement(announce):
	if $Combatinterface/DialogueBox.visible == true:
		yield(self,"ended_text")
		
	var showmessage
	metadata.freeze_time = true
	$Combatinterface/DialogueBox.visible = true
	make_interface_visible(false)
	$Combatinterface/DialogueBox.message(announce)

func _on_DialogueBox_input():
	
	$Camera2D.zoom = Vector2(1,1)
	$Camera2D.zooming = false
	if !can_attack:
		can_attack = true
		emit_signal("can_attack_unlocked")
	metadata.freeze_time = false
	$Combatinterface/DialogueBox.visible = false
	emit_signal("ended_text")
	$Combatinterface/DialogueBox.set_permanent_dialog(false)
	
func draw_particle(path, posx, posy):
	var particle = load(path)
	var  particle_instance = particle.instance()
	particle_instance.position.x = posx
	particle_instance.position.y = posy
	$".".add_child(particle_instance)


func revive(pceomon):
	avatars[pceomon].visible = true
	for enemy in $"Enemies".get_children():
		enemy.foes.append(pceomon)
	for mate in $"Party".get_children():
		mate.mates.append(pceomon)








