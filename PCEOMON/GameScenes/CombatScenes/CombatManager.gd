extends Node2D


var pceomon
var pceo_instance
var avatar : TextureRect
var info : String
signal ended_text
signal pceomon_pressed(pceomon,boss)



# Called when the node enters the scene tree for the first time.
func _ready():
	###TEMPORAL, METER ENEMIGOS
	for i in range(0, metadata.party.size()):
		pceomon = load(metadata.party_paths[i])
		pceo_instance = pceomon.instance()
		pceo_instance.position.x = metadata.combat_position[i][0]
		pceo_instance.position.y = metadata.combat_position[i][1]
		$Party.add_child(pceo_instance)
		pceo_instance.connect("just_attacked", self, "write_attack_text")
		pceo_instance.connect("just_died", self, "pceomon_died")
		pceo_instance.connect("announcement", self, "incoming_announcement")
		pceo_instance.connect("permanent_announcement",self,"incoming_permanent_announcement")
		pceo_instance.connect("sprite_pressed",self,"pceomon_pressed")
		pceo_instance.connect("target_selected",self,"_on_DialogueBox_input")
		pceo_instance.connect("particle", self, "draw_particle")
		self.connect("pceomon_pressed",pceo_instance,"target_selected")
		pceo_instance.manager = self
		avatar = TextureRect.new()
		avatar.texture = load(pceo_instance.avatar_path)
		$Combatinterface/CombatGUI/Fight/Avatars.add_child(avatar)
		load_pceomones()

func write_attack_text(user: String, attack : String, objective : String, string : String):
	if $DialogueBox.visible == true:
		yield(self,"ended_text")
	print("Llega la señal just_attacked")
		
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
				enemy.mates.append(enemy2)
	for mate in $"Party".get_children():
		mate.foes = []
		for enemy in $"Enemies".get_children():
			mate.foes.append(enemy)
			enemy.foes.append(mate)
		for mate2 in $"Party".get_children():
			if mate != mate2:
				mate.mates.append(mate2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func change_interface(turner):
	#print("Cambiando la interfaz:\n a la de : ",turner.name)
	info = str(turner.name) + "\n" + 'VIDA : ' + str(turner.actual_hp) + '/' + str(turner.max_hp)
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack1".text = turner.attack1
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack2".text = turner.attack2
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack 3".text = turner.attack3
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack4".text = turner.attack4
	$"Combatinterface/CombatGUI/MainOptions/Info".text = info
	
func make_interface_visible(visible : bool):
	$"Combatinterface/CombatGUI".visible = visible


func _on_Attack1_pressed():	
	if (metadata.time_exists.size() != 0):
#		if (metadata.time_exists[1].attack1 != $"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack1".text):
#				print("ERROR: La interfaz no cuadra con el pceomon que está a la espera de atacar")
		metadata.time_exists[metadata.time_exists.size()-1].next1()


func _on_Attack2_pressed():
	if (metadata.time_exists.size() != 0):
		metadata.time_exists[metadata.time_exists.size()-1].next2()


func _on_Attack_3_pressed():
	if (metadata.time_exists.size() != 0):
		metadata.time_exists[metadata.time_exists.size()-1].next3()

func _on_Attack4_pressed():
	if (metadata.time_exists.size() != 0):
		metadata.time_exists[metadata.time_exists.size()-1].next4()

func _process(_delta):
	if (metadata.time_exists.size() != 0):
		make_interface_visible(true)
		change_interface(metadata.time_exists[metadata.time_exists.size()-1])
	else:
		make_interface_visible(false)

func pceomon_died(pceomon):
	if pceomon.boss:
		for mate in $"Party".get_children():
			mate.foes.erase(pceomon)
		for enemy in $"Enemies".get_children():
			enemy.mates.erase(pceomon)
	else:
		for mate in $"Party".get_children():
			mate.mates.erase(pceomon)
		for enemy in $"Enemies".get_children():
			enemy.foes.erase(pceomon)
			print(pceomon.name , " elimado de la lista de ", enemy.name)


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
