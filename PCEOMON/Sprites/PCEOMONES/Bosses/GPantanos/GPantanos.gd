extends "res://PCEOMON_combat.gd"


func _ready():
	type = "Programador"
	boss = true
	attack1 = "SOY GPANTANOS"
	actual_stamina = 1
	max_hp = 200000
	actual_hp = max_hp
	next_attack_required_stamina = 500
	rng.randomize()
	
func attack():
	foes[rng.randi_range(0,foes.size()-1)].damage(10)
	actual_stamina = 1
