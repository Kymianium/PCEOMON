extends "res://PCEOMON_combat.gd"

var rng = RandomNumberGenerator.new()

const lucha_de_clases_dmg = 50
const chocolate_healing = 40

func _ready():
	name = "Cafetera Comunista"
	ability = ""
	attack1 = "Café de avellana"
	attack2 = "Lucha de clases"
	attack3 = "Reunión de algebristas"
	attack4 = "Chocolate caliente"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CafeteraComunista_avatar.png"
	next_attack_required_stamina = 1300
	

func next1():
	next_attack_required_stamina = 500
	.next1()
func next2():
	next_attack_required_stamina = 300
	.next2()

func next4():
	next_attack_required_stamina = 200
	.next4()

#SOBRE ESTE ATAQUE: TAL COMO ESTÁ: CUANDO LA CAFETERA METE CAFÉ A ALGUIEN, LE DURA HASTA QUE SE LO DA A OTRO
func atk1():
	#Café de avellanas, aumenta la velocidad con la que se restaura la stamina

	mates[rng.randi_range(0,mates.size()-1)].buff("speed", 1000, 1.5, 0)
func atk2():
	#Roba un poco de vida al enemigo con mas porcentaje de vida y le da una parte al aliado con menor porcentaje de vida

	var more_healed = null
	var less_healed = null
	for enemy in foes:
		if (more_healed == null || enemy.actual_hp/enemy.max_hp > more_healed.actual_hp/more_healed.max_hp):
			more_healed = enemy
	more_healed.damage(lucha_de_clases_dmg)
	for ally in mates:
		if (less_healed == null || less_healed.actual_hp/less_healed.max_hp > ally.actual_hp/ally.max_hp):
			less_healed = ally
	less_healed.heal(lucha_de_clases_dmg/2)
func atk3():
	#Hay que aumentar la evasion, eso no se puede hacer por ahora
	pass
func atk4():
	#Sana al aliado más herido (por porcentajes)
	var less_healed = null
	for ally in mates:
		if (less_healed == null || less_healed.actual_hp/less_healed.max_hp > ally.actual_hp/ally.max_hp):
			less_healed = ally
	less_healed.heal(chocolate_healing)
