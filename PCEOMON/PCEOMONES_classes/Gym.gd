extends "res://PCEOMON_combat.gd"

var anger_acum = 0
var anger = 10000
var max_anger = 10000
	
func _ready():
	type = "Gym"
	._ready()
		

func _process(delta):
	if (actual_hp <= 0):
		return
	elif(actual_stamina==0 and not boss):
		if (not metadata.time_exists.has(self)):
			metadata.time_exists.append(self)
	elif(actual_stamina >= next_attack_required_stamina):
		attack()
		actual_stamina = 0
	elif (metadata.time_should_run()):
		delta_acum+=delta
		if (delta_acum>0.1):
			anger_acum+=getstat(SPEED)
			if anger_acum > 5000/(anger+1):
				selected_foe.take_physical_damage(calculate_physical_damage(anger/2, 0.1))
				anger_acum -= 5000/(anger+1)
				anger=max(anger-1,0)
				$HBoxContainer/StatsSummary/Anger.value = (100*anger)/max_anger
			delta_acum-=0.1
			actual_stamina = actual_stamina + getstat(SPEED)
# warning-ignore:integer_division
			$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
			if poison_counter > 0 and actual_hp > poison_damage:
				poison_counter -= poison_damage
				if (poison_counter <= 0):
					$"HBoxContainer/Status/Poison".visible = false
					emit_signal("announcement","El envenenamiento de " + self.name + " ha terminado")
				self.damage(poison_damage)
	
