extends "res://PCEOMON_combat.gd"

var rng = RandomNumberGenerator.new()
var mate_with_coffe = null           #compañero que está usando el bufo del café

func _ready():
	name = "Cafetera Comunista"
	ability = ""
	attack1 = "Café de avellana"
	attack2 = "Lucha de clases"
	attack3 = "Reunión de algebristas"
	attack4 = "Chocolate caliente"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CafeteraComunista_avatar.png"
	next_attack_required_stamina = 1200
	

#SOBRE ESTE ATAQUE: TAL COMO ESTÁ CUANDO LA CAFETERA METE CAFÉ A ALGUIEN, LE DURA HASTA QUE SE LO DA A OTRO
func atk1():
	#Café de avellanas, aumenta la velocidad con la que se restaura la stamina
	if (mate_with_coffe != null):
		mates[mate_with_coffe].next_attack_required_stamina *= 1.5
	mate_with_coffe = rng.randi_range(0,foes.size()-1)
	mates[mate_with_coffe].next_attack_required_stamina /= 1.5
	end_attack()
	
