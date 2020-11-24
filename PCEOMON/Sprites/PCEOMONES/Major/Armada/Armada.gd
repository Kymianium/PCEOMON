extends "res://PCEOMONES_classes/Alcoholic.gd"


func _ready():
	$HBoxContainer/StatsSummary/Shield.value = 0
	arrow = $Arrow
	maxalcohol = 500
	alcohol = 0
	name = "Armada"
	ability = "Rapunzel"
	attack1 = "Postureo"
	attack2 = "El Quijote"
	attack3 = "Esto no es na"
	attack4 = "¿Un lolete?"
	type = "Alcohólico"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Major/Armada/Armada_avatar.png"
	
func next1():
	if (alcohol >= 50):
		next_attack_required_stamina = 200
		select_combat("¿A quién le quieres enviar tu instastory?",ENEMY)
		.next1()
	else:
		emit_signal("announcement","No tienes suficiente alcohol en sangre para eso, zagal")
func next2():
	if (alcohol >= 80):
		select_combat("Un caballero hidalgo... ¿Quién lo dijo?", ENEMY)
		next_attack_required_stamina = 200
		.next2()
	else:
		emit_signal("announcement","No tienes suficiente alcohol en sangre para eso, zagal")
func next3():
	next_attack_required_stamina = 150
	.next3()
func next4():
	if (alcohol >= 400):
		next_attack_required_stamina = 300
		select_combat("ESTOY EN LA GRIETA. MATAR. MATAR.                               [shake level=30 freq = 1]MATAR. [/shake]", ENEMY)
		.next4()
	else:
		emit_signal("announcement","No tienes suficiente alcohol en sangre para eso, zagal")
func atk1():
	#Postureo
	#Armada alza en alto su móvil y graba un instastory lo cual hace que los enemigos entren en
	#estado de baile desenfrenado. A mitad del baile, Armada se convierte en una fuente de pota y hace	
	#daño químico a todos los que bailan.
	alcohol-=50
	$"HBoxContainer/StatsSummary/Alcohol".value = float(alcohol)/maxalcohol *100
	unicast_damage(500,0.5, CHEMICAL_DMG, targets,"Postureo","Esta pa [rainbow] mejores amigos [/rainbow].")
func atk2():
	#El Quijote
	#Armada lanza al aire la pregunta ¿Qué era el quijote? Al primer enemigo que conteste &quot;Un
	#caballero hidalgo &quot; Armada le contestará &quot;hijoputa el que se deje algo &quot; y este enemigo deberá beberse
	#una garrafa de 8 litros de las de paellas, entrando este enemigo en un estado de embriaguez tal que
	#durante las siguientes rondas perderá parte de su vida debido a las tremendas potas que lanzará
	#(envenenamiento grave).
	alcohol-=80
	$"HBoxContainer/StatsSummary/Alcohol".value = float(alcohol)/maxalcohol *100
	poison(targets,rng.randi_range(800,1000))
	emit_signal("just_attacked", "Armada", "Quijote", targets[0].name, "¡Hijo puta el que se deje algo! " + targets[0].name + " va muy ciego")

func atk3():
	#Esto no es na`
	# Armada se bebe una garrafa como si fuera agua, lo cual no solo no le afecta, si no que
	#actúa cual espinacas de popeye, entrando Armada en un estado de motivación y felicidad que le
	#profiere velocidad de ataque, daño químico y evasión. Armada termina su ataque lanzando un soberbio
	#eructo que infringe daño químico. Recupera alcohol en sangre.
	next_attack_required_stamina = 700
	alcohol+=200
	if alcohol>maxalcohol:
		alcohol=maxalcohol
	$"HBoxContainer/StatsSummary/Alcohol".value = float(alcohol)/maxalcohol *100
	emit_signal("just_attacked", "Armada", "Esto no es na'", "", "[wave] ¡Este hijo de puta quiere emborracharse![/wave]")

func atk4():
	#¿Un lolete?
	#Armada va tan borracho que se piensa que está en la grieta del invocador y se abalanza
	#contra un pceomón enemigo, comenzando a meterle de ostias y rociarle alcohol tóxico lo cual infiere
	#daño físico y mucho daño químico. Además si el enemigo tiene el 20% de la vida o menos, le oneshotea.
	var damage
	var damage_done
	if float(targets[0].actual_hp)/targets[0].max_hp <= 0.2:
		unicast_damage(targets[0].max_hp,0, TRUE_DMG, targets,"¿Un lolete?","¡El lugar está lleno de [shake]VÍSCERAS[/shake]!")
		alcohol-=400
		$"HBoxContainer/StatsSummary/Alcohol".value = float(alcohol)/maxalcohol *100
		return
	else:
		unicast_damage(1000,1, PHYSICAL_DMG, targets,"¿Un lolete?","¡El lugar está lleno de [shake]VÍSCERAS[/shake]!")
		alcohol-=400
		$"HBoxContainer/StatsSummary/Alcohol".value = float(alcohol)/maxalcohol *100
	
