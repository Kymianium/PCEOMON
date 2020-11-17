extends "res://PCEOMONES_classes/Gym.gd"

var binded_ally = null
const binded_buff = 1.2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	max_anger = 100
	anger = 100
	name = "Chito"
	ability = "Dedos rápidos"
	attack1 = "Placaje"
	attack2 = "Cheat Meal"
	attack3 = "Beso"
	attack4 = "911"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Major/Chito/Chito_avatar.png"

	
func next1():
	next_attack_required_stamina = 300
	select_combat("¿A quién hay que [shake level=10] partirle[/shake] las piernas?", false)
	.next1()
func next2():
	next_attack_required_stamina = 400
	.next2()
	
func next3():
	next_attack_required_stamina = 250
	select_combat("Uy... ¿Quién es el travieso me ha guiñado un ojo? :)", true)
	.next3()
func next4():
	next_attack_required_stamina = 1000
	.next4()
	
	
	#LOS ATAQUES ESTÁN SIN PROGRAMAR
	
func atk1():
	unicast_damage(selected_foe.take_physical_damage(calculate_physical_damage(100, 0.5)),selected_foe.name,"Placaje","¡La puta madre! Eso tuvo que doler...")
	emit_signal("attacked", self, selected_foe, calculate_physical_damage(100, 0.5),PHYSICAL_DMG)
func atk2():
	anger=min(anger+30,max_anger)
	$HBoxContainer/StatsSummary/Anger.value = (100*anger)/max_anger
	emit_signal("just_attacked", "Chito", "Cheat Meal", "", "¡AQUÍ LLEGAN LOS [wave][rainbow] MACARRAS DEL PODER! [/rainbow][/wave]")
func atk3():
	binded_ally = selected_mate
	emit_signal("just_attacked", "Chito", "Besito en la boca", "", "La pasión se siente en el ambiente entre Chito y " + selected_mate.name + "... ¡Dejadles intimidad!")

func atk4():
	var tried_to_deal 
	var damage
	if float(selected_foe.actual_hp) < calculate_physical_damage(1000, 1):
		selected_foe.damage(selected_foe.max_hp)
		tried_to_deal = selected_foe.max_hp
		damage = TRUE_DMG
	else:
		tried_to_deal = calculate_physical_damage(1000,1)
		damage = PHYSICAL_DMG
		selected_foe.take_physical_damage(tried_to_deal)
	if damage==PHYSICAL_DMG:
		unicast_damage(selected_foe.take_physical_damage(tried_to_deal),selected_foe.name,"911","Hoy cierran los aeropuertos y colapsan las torres.")
	else:
		unicast_damage(selected_foe.damage(tried_to_deal),selected_foe.name,"911","Hoy cierran los aeropuertos y colapsan las torres.")
	emit_signal("attacked", self, [selected_foe], tried_to_deal, damage)





	
####
##
## HACER QUE CAPTURE LA SEÑAL DEL PCEOMÓN BINDED Y DEL PCEOMÓN TARGET.
##
####
