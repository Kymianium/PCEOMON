extends "res://PCEOMONES_classes/MINOR.gd"

var selected_mate
var tired_targets = {}

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

func new_foe(foe):
	foe.connect("attacked", self, "passive")
	.new_foe(foe)

func passive(user, target, damage : Array, damage_type):
	if (selected_mate in target) and damage_type == PHYSICAL_DMG:
		unicast_damage(100, 0.2, PHYSICAL_DMG, [user],"MODIFICAR TEXTO","MODIFICAR TEXTO")

func next1():
	next_attack_required_stamina = 700
	select_combat("Selecciona a quien quieres confundir",ENEMY)
	.next1()
func next2():
	next_attack_required_stamina = 300
	select_combat("¡Selecciona a quién quieres asustar!",ENEMY)
	.next2()

func next3():
	next_attack_required_stamina = 400
	select_combat("Te encuentras cansado, muy cansado...",ENEMY)
	.next3()

func next4():
	next_attack_required_stamina = 200
	var sleeping = []
	for enemy in foes:
		if enemy.stun_counter > 0:
			sleeping.append(enemy)
	select_custom_combat("Bienvenido a tu peor [shake level=20]pesadilla[/shake]",sleeping)
	.next4()


func atk1():
	targets[0].set_stamina(0)
	emit_signal("just_attacked", self.name, "Confusión", targets[0].name, "¡" + targets[0].name + " ha perdido la concentración!")
	.atk1()
	
func atk2():
	emit_signal("just_attacked", self.name, "Paranoia", targets[0].name, "¡La mente de " + targets[0].name + "ahora está debilitada!") 
	buff(targets, PSYCHOLOGYCAL_DFC, 3000, 0.5, 0)
	.atk2()
func atk3():
	if targets[0] in tired_targets:
		tired_targets[targets[0]] += 1
		if tired_targets[targets[0]] == 3:
			tired_targets[targets[0]] = 0
			targets[0].stun_counter = 7000
			emit_signal("just_attacked",self.name,"Extenuar",targets[0].name,"¡" + targets[0].name + " se ha quedado durmiendo!")
		#TODO Crear estado durmiendo y dormir aquí si se llega a cierto umbral. Resetar después el valor de tired_targets
		#Hacer en ese caso el emit signal también. Modificar el otro para que solo pase por un emit signal
		else:
			buff(targets, SPEED, 2000, 0.5, 0)
			emit_signal("just_attacked",self.name, "Extenuar",targets[0].name, targets[0].name + " cada vez está más cansado")
	else:
		tired_targets[targets[0]] = 1
		buff(targets, SPEED, 2000, 0.5, 0)
		emit_signal("just_attacked",self.name, "Extenuar",targets[0].name, targets[0].name + " cada vez está más cansado")
	.atk3()
func atk4():
	if (targets[0].stun_counter <= 0):
		emit_signal("just_attacked",self.name,"Terror nocturno",targets[0].name,"¡Pero ya no estaba durmiendo!")
	else:
		unicast_damage(500,3, PSYCHOLOGYCAL_DMG, targets,"Terror nocturno","Una sombra puntiaguda acecha en la noche...")
	.atk4()
