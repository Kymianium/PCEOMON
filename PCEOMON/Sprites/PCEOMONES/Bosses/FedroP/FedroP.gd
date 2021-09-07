extends "res://PCEOMON_combat.gd"

var phase2 = load("res://Sprites/PCEOMONES/Bosses/FedroP/Phase2.png")
var phase3 = load("res://Sprites/PCEOMONES/Bosses/FedroP/Phase3.png")
var phase = 1
func _ready():
	type = "R4"
	boss = true
	attack1 = "SOY FEDRO P"
	name = "FedroP"
	actual_stamina = 1
	max_hp = 20000
	actual_hp = max_hp
	next_attack_required_stamina = 250
	arrow = $Arrow
	rng.randomize()


func attack():
	if phase==1:
		unicast_damage(5, 0.2, PSYCHOLOGYCAL_DMG, [foes[rng.randi_range(0,foes.size()-1)]],"Humillación","¡Fedro P le ha dejado bien claro que es una mierda y debe volver a primero!")
	elif phase==2:
		unicast_damage(8, 0.2, PSYCHOLOGYCAL_DMG, [foes[rng.randi_range(0,foes.size()-1)]],"Riemann–Stieltjes","¡La integración le ha hecho caldo!")
	elif phase==3:
		unicast_damage(12, 0.2, PSYCHOLOGYCAL_DMG, [foes[rng.randi_range(0,foes.size()-1)]],"Control mental","¡La critatura que habita en el interior de Fedro intenta tomar el control!")
	
	actual_stamina = 1

func damage(damage):
	if actual_hp-damage < 10000 and phase==1:
		$SpriteContainer/Sprite.texture = phase2
		phase+=1
		next_attack_required_stamina = 200
	elif actual_hp-damage < 5000 and phase==2:
		$SpriteContainer/Sprite.texture = phase3
		phase+=1
		heal(self, 10000)
		next_attack_required_stamina = 100
	.damage(damage)
