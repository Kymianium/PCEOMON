extends Node2D


var pceomon
var pceo_instance
var avatar : TextureRect
var info : String

func stop_time():
	pass

func continue_time():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	###TEMPORAL, METER ENEMIGOS
	for i in range(0, metadata.party.size()):
		pceomon = load(metadata.party_paths[i])
		pceo_instance = pceomon.instance()
		pceo_instance.position.x = metadata.combat_position[i][0]
		pceo_instance.position.y = metadata.combat_position[i][1]
		$Party.add_child(pceo_instance)
	#	pceo_instance.connect("my_turn", self, "change_interface", [pceo_instance])
		avatar = TextureRect.new()
		avatar.texture = load(pceo_instance.avatar_path)
		$Combatinterface/CombatGUI/Fight/Avatars.add_child(avatar)
		load_pceomones()

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
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack1".visible = visible
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack1/Attack2".visible = visible
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack 3".visible = visible
	$"Combatinterface/CombatGUI/Fight/Attacks/Attack2/Attack4".visible = visible
	$"Combatinterface/CombatGUI/MainOptions/Info".visible = visible


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

func _process(delta):
	if (metadata.time_exists.size() != 0):
		make_interface_visible(true)
		change_interface(metadata.time_exists[metadata.time_exists.size()-1])
	else:
		make_interface_visible(false)
