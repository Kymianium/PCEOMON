extends "res://PCEOMON_combat.gd"

var rng = RandomNumberGenerator.new()

func _ready():
	boss = true
	attack1 = "SOY GPANTANOS"
	actual_stamina = 0
	max_hp = 10000
	actual_hp = max_hp
	next_attack_required_stamina = 5500
	rng.randomize()
	
func attack():
	foes[rng.randi_range(0,foes.size()-1)].damage(10)

func _process(delta):
	if (actual_hp <= 0):
		return
	elif(actual_stamina >= next_attack_required_stamina):
		attack()
		actual_stamina = 0
	elif (metadata.time_exists.size() == 0):
		delta_acum+=delta
		if (delta_acum>0.01):
			delta_acum-=0.01
			actual_stamina = actual_stamina + getstat("speed")
			$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
			
			if poison_counter > 0 and actual_hp > poison_damage:
				poison_counter -= poison_damage
				self.damage(poison_damage)
