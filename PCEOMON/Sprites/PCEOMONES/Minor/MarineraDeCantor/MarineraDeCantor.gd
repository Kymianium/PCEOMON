extends "res://PCEOMON_combat.gd"


func _ready():
	name = "Marinera de Cantor"
	ability = "No numerable"
	attack1 = "Ensaladillado"
	attack2 = "Medida nula"
	attack3 = "Rosquillazo"
	attack4 = "Aperitivo"
	type = "Menor"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/MarineraDeCantor/MarineraDeCantor_avatar.png"
	next_attack_required_stamina = 1300
	

func next1():
	next_attack_required_stamina = 500
	yield(select_combat("¡Selecciona a quién hay que ensaladillar!",ENEMY), "completed")
	.next1()
func next2():
	next_attack_required_stamina = 300
	yield(select_combat("¡Selecciona quién tiene medida nula!",ALLY), "completed")
	.next2()

func next3():
	next_attack_required_stamina = 400
	yield(select_combat("Alguien se va a llevar un rosquillazo...",ENEMY), "completed")
	.next3()

func next4():
	next_attack_required_stamina = 2000
	yield(select_combat("Moriré... Por ti...",ALLY), "completed")
	.next4()


func atk1():
	buff(targets, SPEED, 10000, 0.6, 0)
	unicast_damage(100, 0.3, CHEMICAL_DMG, targets,"Ensaladillado","¡Mayonesa, huevo, zanahora, yo qué coño sé! ¡Sufre mamón!")

	
func atk2():
	emit_signal("just_attacked", self.name, "Medida nula", "", "¿¡Dónde se ha metido " + targets[0].name + "!?")
	buff(targets, EVASION, 3000, 0.5, 0)
func atk3():
	unicast_damage(100, 0.2, CHEMICAL_DMG, targets,"Rosquillazo","... Em... Sí, bueno... Le dió un rosquillazo. Don't mess with Cantor, I guess.")
func atk4():
	permanent_buff(targets, CHEMICAL_DMG, 1.5, 50)
	permanent_buff(targets, PHYSICAL_DMG, 1.5, 50)
	permanent_buff(targets, PSYCHOLOGYCAL_DMG, 1.5, 50)
	permanent_buff(targets, CHEMICAL_DFC, 1.5, 50)
	permanent_buff(targets, PHYSICAL_DFC, 1.5, 50)
	permanent_buff(targets, PSYCHOLOGYCAL_DFC, 1.5, 50)
	permanent_buff(targets, SPEED, 1.5, 0)
	damage(max_hp)
	emit_signal("just_attacked",self.name,"Aperitivo","","D.E.P., Marinera de Cantor. Siempre guardaremos un huequito de medida nula para ti en nuestro corazón <3")

