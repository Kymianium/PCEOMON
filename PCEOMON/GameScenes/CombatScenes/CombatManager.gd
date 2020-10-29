extends Node2D


var pceomon
var pceo_instance
var avatar : TextureRect

func stop_time():
	pass

func continue_time():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	###TEMPORAL, CAMBIAR PARA HACER GENERAL
	for i in range(0, metadata.party.size()):
		pceomon = load(metadata.party_paths[i])
		pceo_instance = pceomon.instance()
		pceo_instance.position.x = metadata.combat_position[i][0]
		pceo_instance.position.y = metadata.combat_position[i][1]
		$Party.add_child(pceo_instance)
		
		avatar = TextureRect.new()
		avatar.texture = load(metadata.avatar_paths[i])
		$Combatinterface/CombatGUI/Fight/Avatars.add_child(avatar)
	for mate in $"Party".get_children():
		$"Enemies/GPantanos".foes.append(mate)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Attack1_pressed():
	if (metadata.time_exists != 0):
		$"Enemies/GPantanos".damage(10)
		metadata.time_exists -= 1


