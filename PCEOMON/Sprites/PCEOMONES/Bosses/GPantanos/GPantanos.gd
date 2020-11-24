extends "res://PCEOMON_combat.gd"


func _ready():
	type = "Programador"
	boss = true
	attack1 = "SOY GPANTANOS"
	name = "GPantanos"
	actual_stamina = 1
	max_hp = 200000
	actual_hp = max_hp
	next_attack_required_stamina = 500
	rng.randomize()
	
func attack():
	unicast_damage(10, 0.2, PSYCHOLOGYCAL_DMG, [foes[rng.randi_range(0,foes.size()-1)]],"Malloc()","¡Memory allocate, hijo de puta!")
	actual_stamina = 1
