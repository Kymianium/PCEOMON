extends "res://PCEOMON_combat.gd"

var rng = RandomNumberGenerator.new()

func _ready():
	actual_stamina = 0
	max_hp = 10000
	actual_hp = max_hp
	next_attack_required_stamina = 5500
	rng.randomize()
	
func attack():
	foes[rng.randi_range(0,foes.size()-1)].damage(10)
