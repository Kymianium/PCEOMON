extends "res://PCEOMONES_classes/MINOR.gd"


func _ready():
	name = "Función de Weierstrass"
	ability = "Pincho"	#Por hacer
	attack1 = "Confusión"
	attack2 = "Paranoia"	#Por hacer
	attack3 = "Extenuar"	#Por hacer
	attack4 = "Terror nocturno"	   #Por hacer
	type = "Menor"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/FuncionDeWeierstrass/FuncionDeWeierstrass_avatar.png"
	next_attack_required_stamina = 1300
	

func next1():
	next_attack_required_stamina = 700
	select_combat("Selecciona a quien quieres confundir",ENEMY)
	.next1()
func next2():
	next_attack_required_stamina = 300
	select_combat("¡Selecciona quién tiene medida nula!",ALLY)
	.next2()

func next3():
	next_attack_required_stamina = 400
	select_combat("Alguien se va a llevar un rosquillazo...",ENEMY)
	.next3()

func next4():
	next_attack_required_stamina = 2000
	select_combat("Moriré... Por ti...",ALLY)
	.next4()


func atk1():
	targets[0].set_stamina(0)
	emit_signal("just_attacked", self.name, "Confusión", targets[0].name, "¡" + targets[0].name + " ha perdido la concentración!")
	.atk1()
	
func atk2():
	emit_signal("just_attacked", self.name, "Medida nula", "", "¿¡Dónde se ha metido " + targets[0].name + "!?")
	buff(targets, EVASION, 3000, 0.5, 0)
	.atk2()
func atk3():
	unicast_damage(100, 0.2, CHEMICAL_DMG, targets,"Rosquillazo","... Em... Sí, bueno... Le dió un rosquillazo. Don't mess with Cantor, I guess.")
	.atk3()
func atk4():
	permanent_buff(targets, [CHEMICAL_DMG], 1.5, 50)
	permanent_buff(targets, [PHYSICAL_DMG], 1.5, 50)
	permanent_buff(targets, [PSYCHOLOGYCAL_DMG], 1.5, 50)
	permanent_buff(targets, [CHEMICAL_DFC], 1.5, 50)
	permanent_buff(targets, [PHYSICAL_DFC], 1.5, 50)
	permanent_buff(targets, [PSYCHOLOGYCAL_DFC], 1.5, 50)
	permanent_buff(targets, [SPEED], 1.5, 0)
	damage(max_hp)
	emit_signal("just_attacked",self.name,"Aperitivo","","D.E.P., Marinera de Cantor. Siempre guardaremos un huequito de medida nula para ti en nuestro corazón <3")
	.atk4()
