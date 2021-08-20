extends Node2D


var adjusted_interface = 0
var pceomon
var pceo_instance
var avatar : TextureRect
var avatars = {}
var info : String
var R4 = {}

var rng = RandomNumberGenerator.new()




signal pceomon_pressed(pceomon,boss)
signal ended_text


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _ready():
	metadata.dimensions["default"] = [] # es algo así?
	###TEMPORAL, METER ENEMIGOS
	$Combatinterface.connect("text", self, "incoming_announcement")
	for i in range(0, metadata.party.size()):
		pceomon = load(metadata.party_paths[i])
		pceo_instance = pceomon.instance()
		pceo_instance.position.x = metadata.combat_position[i][0]
		pceo_instance.position.y = metadata.combat_position[i][1]
		metadata.dimensions["default"].append(pceo_instance)
		$Party.add_child(pceo_instance)
		pceo_instance.connect("just_attacked", self, "write_attack_text")
		pceo_instance.connect("died", self, "pceomon_died")
		pceo_instance.connect("announcement", self, "incoming_announcement")
		pceo_instance.connect("permanent_announcement",self,"incoming_permanent_announcement")
		pceo_instance.connect("sprite_pressed",self,"pceomon_pressed")
		pceo_instance.connect("target_selected",self,"_on_DialogueBox_input")
		pceo_instance.connect("particle", self, "draw_particle")
		pceo_instance.connect("revive",self,"revive")
		self.connect("pceomon_pressed",pceo_instance,"target_selected")
		if (pceo_instance.type == "R4"):
			metadata.dimensions[pceo_instance.name] = [pceo_instance]
			pceo_instance.connect("dimension_changed",self,"adjust_dimension")
			pceo_instance.connect("release_pceomon",self,"release_pceomon")
		pceo_instance.manager = self
		avatar = TextureRect.new()
		avatar.texture = load(pceo_instance.avatar_path)
		avatars[pceo_instance]=avatar
		#$Combatinterface/CombatGUI/Fight/Avatars.add_child(avatar)
	for enemy in $"Enemies".get_children():
		metadata.dimensions["default"].append(enemy)
		enemy.connect("sprite_pressed",self,"pceomon_pressed")
		enemy.connect("just_attacked", self, "write_attack_text")
		enemy.connect("died", self, "pceomon_died")
		enemy.connect("announcement", self, "incoming_announcement")
		enemy.connect("permanent_announcement",self,"incoming_permanent_announcement")
		enemy.connect("target_selected",self,"_on_DialogueBox_input")
		enemy.connect("particle", self, "draw_particle")
		enemy.connect("revive",self,"revive")
		self.connect("pceomon_pressed",enemy,"target_selected")
	load_pceomones()
	self.connect("pceomon_pressed",$ObjectMenu,"target_selected")
	$ObjectMenu.connect("announcement", self, "incoming_announcement")
	$ObjectManager.connect("announcement",self,"incoming_announcement")
	#Iniciamos los gyms y los R4
	for pceo in $"Party".get_children():
		if (pceo.need_to_select):
			pceo.needed_select()
	#Conectamos con el objectManager
	#$ObjectManager.connect("object_selected",self,"Object")


func write_attack_text(user: String, attack : String, objective : String, string : String):
	if $DialogueBox.visible == true:
		yield(self,"ended_text")
		
	var showmessage
	metadata.freeze_time = true
	$DialogueBox.visible = true
	if(objective == ""):
		showmessage = "¡" + user + " usó " + attack + "! " + string
	else:
		showmessage = "¡" + user + " usó " + attack + " contra " + objective + "! " + string
	make_interface_visible(false)
	$DialogueBox.message(showmessage)




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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func change_interface(turner):
	#print("Cambiando la interfaz:\n a la de : ",turner.name)
	$Combatinterface/CombatGUI/Fight/Avatar.texture = load(turner.avatar_path)
	var txt = File.new()
	if turner.type != "Menor":
		txt.open("res://GameScenes/Menues/Selection/PCEOMONES/Major/" + turner.name.replace(" ","") +"Info.txt", File.READ)
	else:
		txt.open("res://GameScenes/Menues/Selection/PCEOMONES/Minor/" + turner.name.replace(" ","") +"Info.txt", File.READ)
	txt.get_line().replace("\\n","\n")
	txt.get_line().replace("\\n","\n")
	txt.get_line().replace("\\n","\n")
	var abilityname = txt.get_line().replace("\\n","\n")
	txt.get_line().replace("\\n","\n")
	var abilitydesc = txt.get_line().replace("\\n","\n")
	var att1name = txt.get_line().replace("\\n","\n")
	txt.get_line().replace("\\n","\n")
	var att1desc = txt.get_line().replace("\\n","\n")
	var att2name = txt.get_line().replace("\\n","\n")
	txt.get_line().replace("\\n","\n")
	var att2desc = txt.get_line().replace("\\n","\n")
	var att3name = txt.get_line().replace("\\n","\n")
	txt.get_line().replace("\\n","\n")
	var att3desc = txt.get_line().replace("\\n","\n")
	var att4name = txt.get_line().replace("\\n","\n")
	txt.get_line().replace("\\n","\n")
	var att4desc = txt.get_line().replace("\\n","\n")
	
	$Combatinterface/CombatGUI/Data/Attacks1/Atk1.text = att1name
	$Combatinterface/CombatGUI/Data/Attacks1/Atk2.text = att2name
	$Combatinterface/CombatGUI/Data/Attacks2/Atk3.text = att3name
	$Combatinterface/CombatGUI/Data/Attacks2/Atk4.text = att4name
	$Combatinterface/CombatGUI/Data/Passive/Passive.text = abilityname
	$Combatinterface.atk1 = att1desc
	$Combatinterface.atk2 = att2desc
	$Combatinterface.atk3 = att3desc
	$Combatinterface.atk4 = att4desc
	$Combatinterface.passive = abilitydesc
	
	info = str(turner.name) + "\n" + 'VIDA : ' + str(turner.actual_hp) + '/' + str(turner.max_hp)
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack1".text = turner.attack1
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack2".text = turner.attack2
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack3".text = turner.attack3
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack4".text = turner.attack4
	$"Combatinterface/CombatGUI/MainOptions/Info".text = info
	
func make_interface_visible(visible : bool):
	$"Combatinterface/CombatGUI".visible = visible


func adjust_dimension(dimension, pceomon):
	
	if pceomon.name == "Azul42" and rng.randf() < 0.5:
		return
	var avatar = load("res://Sprites/PCEOMONES/Major/" + dimension.name + "/" + dimension.name + "_avatar.png")
	var icon = Sprite.new()
	add_child(icon)
	icon.texture = avatar
	icon.position.x = pceomon.position.x + pceomon.get_size().x/2
	icon.position.y = pceomon.position.y + pceomon.get_size().y
	icon.modulate.a8 = 200
	icon.scale.x = 0.5
	icon.scale.y = 0.5
	 
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
	check_targets(pceomon, dimension)

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

func _on_Attack1_pressed():	
	if (metadata.time_exists.size() != 0):
#		if (metadata.time_exists[1].attack1 != $"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack1".text):
#				print("ERROR: La interfaz no cuadra con el pceomon que está a la espera de atacar")
		metadata.time_exists[metadata.time_exists.size()-1].next1()
		adjusted_interface = metadata.time_exists.size()


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
	print("Se va a usar item ", selected, pceomon)
	if (metadata.time_exists.size() != 0):
		var ref = $ObjectManager.get_func_from_name(selected)
		metadata.time_exists[metadata.time_exists.size()-1].nextobject(ref,pceomon)
		adjusted_interface = metadata.time_exists.size()


func _process(_delta):
	#print(str(adjusted_interface) + str(metadata.time_exists.size()))
	if (metadata.time_exists.size() != 0 ):
		make_interface_visible(true)
		#print(metadata.time_exists[metadata.time_exists.size()-1].name)
		change_interface(metadata.time_exists[metadata.time_exists.size()-1])
		if adjusted_interface != metadata.time_exists.size(): 
#			print(metadata.time_exists[metadata.time_exists.size()-1].name)
#			adjust_dimension(metadata.time_exists[metadata.time_exists.size()-1])
			adjusted_interface = metadata.time_exists.size()
	else:
		make_interface_visible(false)

func pceomon_died(pceomon):
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


func pceomon_pressed(pceomon,boss):
	emit_signal("pceomon_pressed",pceomon,boss)

func incoming_permanent_announcement(announce):
	$DialogueBox.set_permanent_dialog(true)
	incoming_announcement(announce)

func incoming_announcement(announce):
	make_interface_visible(false)
	metadata.freeze_time = true
	$DialogueBox.visible = true
	$DialogueBox.message(announce)

func _on_DialogueBox_input():
	metadata.freeze_time = false
	$DialogueBox.visible = false
	#make_interface_visible(true)
	emit_signal("ended_text")
	$DialogueBox.set_permanent_dialog(false)
	
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








