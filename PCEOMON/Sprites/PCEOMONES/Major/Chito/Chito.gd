extends "res://PCEOMONES_classes/Gym.gd"

var binded_ally = null
var powerup = false
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
	select_combat("¿A quién hay que [shake level=10] partirle[/shake] las piernas?", ENEMY)
	.next1()
func next2():
	next_attack_required_stamina = 400
	.next2()
	
func next3():
	next_attack_required_stamina = 250
	select_combat("Uy... ¿Quién es el travieso me ha guiñado un ojo? :)", ALLY)
	.next3()
func next4():
	next_attack_required_stamina = 1000
	if (selected_foe == null):
		emit_signal("announcement", "¡No tienes a nadie seleccionado!")
		return
	targets.append(selected_foe)
	.next4()
	
	
	#LOS ATAQUES ESTÁN SIN PROGRAMAR
	
func atk1():
	if not targets.empty():
		selected_foe = targets[0]
	move()
	unicast_damage(100,0.5, PHYSICAL_DMG, targets,"Placaje","¡La puta madre! Eso tuvo que doler...")
	emit_signal("camera_zoom",self)
	.atk1()
func atk2():
	anger=min(anger+30,max_anger)
	$HBoxContainer/StatsSummary/Anger.value = (100*anger)/max_anger
	emit_signal("just_attacked", "Chito", "Cheat Meal", "", "¡AQUÍ LLEGAN LOS [wave][rainbow] MACARRAS DEL PODER! [/rainbow][/wave]")
	emit_signal("camera_zoom",self)
	.atk2()
func atk3():
	binded_ally = targets[0]
	emit_signal("just_attacked", "Chito", "Besito en la boca", "", "La pasión se siente en el ambiente entre Chito y " + binded_ally.name + "... ¡Dejadles intimidad!")
	emit_signal("camera_zoom",self)
	.atk3()
func atk4():
	if targets[0].actual_hp < calculate_physical_damage(1000, 1):
		unicast_damage(targets[0].max_hp,0, TRUE_DMG, targets,"911","BOOOM, [shake level=10]¡CHEQUEA ESTOS MOVIMIENTOS, GEORGE BUSH![/shake]")
	else:
		unicast_damage(targets[0].max_hp,0, TRUE_DMG, targets,"911","Espera, ¿hacia dónde va ese avión...? . . . [shake level=10]OH DIOS MÍO[/shake]")
	emit_signal("camera_zoom",self)
	.atk4()




	
####
##
## HACER QUE CAPTURE LA SEÑAL DEL PCEOMÓN BINDED Y DEL PCEOMÓN TARGET.
##
####
