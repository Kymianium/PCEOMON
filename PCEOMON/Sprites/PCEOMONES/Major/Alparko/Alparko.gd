extends "res://PCEOMON_combat.gd"

var rng = RandomNumberGenerator.new()

func _ready():
	name = "Alparko"
	._ready()
	max_hp = 1000
	actual_hp = max_hp
	avatar_path = "res://Sprites/PCEOMONES/Major/Alparko/Alparko_avatar.png"
	next_attack_required_stamina = 1000
func atk1():
	foes[rng.randi_range(0,foes.size()-1)].damage(200)
	end_attack()
	pass
