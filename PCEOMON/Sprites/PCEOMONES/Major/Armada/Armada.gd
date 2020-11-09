extends "res://PCEOMON_combat.gd"


var alcohol

func _ready():
	name = "Armada"
	ability = "Rapunzel"
	attack1 = "Postureo"
	attack2 = "El Quijote"
	attack3 = "Esto no es na"
	attack4 = "¿Un lolete?"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Major/Armada/Armada_avatar.png"
	
func next1():
	if ($"HBoxContainer/StatsSummary/Alcohol".value >= 50):
		next_attack_required_stamina = 200
		.next1()
	else:
		emit_signal("announcement","No tienes suficiente alcohol en sangre para eso, zagal")
func next2():
	if ($"HBoxContainer/StatsSummary/Alcohol".value >= 60):
		next_attack_required_stamina = 200
		.next2()
	else:
		emit_signal("announcement","No tienes suficiente alcohol en sangre para eso, zagal")
func next3():
	next_attack_required_stamina = 150
	.next3()
func next4():
	if ($"HBoxContainer/StatsSummary/Alcohol".value >= 90):
		next_attack_required_stamina = 300
		.next4()
	else:
		emit_signal("announcement","No tienes suficiente alcohol en sangre para eso, zagal")
func atk1():
	#Postureo
	#Armada alza en alto su móvil y graba un instastory lo cual hace que los enemigos entren en
	#estado de baile desenfrenado. A mitad del baile, Armada se convierte en una fuente de pota y hace	
	#daño químico a todos los que bailan.
	foes[rng.randi_range(0,foes.size()-1)].damage(500)
	$"HBoxContainer/StatsSummary/Alcohol".value = $"HBoxContainer/StatsSummary/Alcohol".value - 50
	alcohol = $"HBoxContainer/StatsSummary/Alcohol".value
	emit_signal("just_attacked", "Armada", "Postureo", "", "Esta pa [rainbow] mejores amigos [/rainbow]")
	
	
func atk2():
	#El Quijote
	#Armada lanza al aire la pregunta ¿Qué era el quijote? Al primer enemigo que conteste &quot;Un
	#caballero hidalgo &quot; Armada le contestará &quot;hijoputa el que se deje algo &quot; y este enemigo deberá beberse
	#una garrafa de 8 litros de las de paellas, entrando este enemigo en un estado de embriaguez tal que
	#durante las siguientes rondas perderá parte de su vida debido a las tremendas potas que lanzará
	#(envenenamiento grave).
	$"HBoxContainer/StatsSummary/Alcohol".value = $"HBoxContainer/StatsSummary/Alcohol".value - 60
	alcohol = $"HBoxContainer/StatsSummary/Alcohol".value
	var attacked = foes[rng.randi_range(0,foes.size()-1)]
	attacked.poison(rng.randi_range(800,1000))
	emit_signal("just_attacked", "Armada", "Quijote", attacked.name, "¡Hijo puta el que se deje algo! " + attacked.name + " va muy ciego")
	
func atk3():
	#Esto no es na`
	# Armada se bebe una garrafa como si fuera agua, lo cual no solo no le afecta, si no que
	#actúa cual espinacas de popeye, entrando Armada en un estado de motivación y felicidad que le
	#profiere velocidad de ataque, daño químico y evasión. Armada termina su ataque lanzando un soberbio
	#eructo que infringe daño químico. Recupera alcohol en sangre.
	next_attack_required_stamina = 700
	$"HBoxContainer/StatsSummary/Alcohol".value = $"HBoxContainer/StatsSummary/Alcohol".value + 20
	alcohol = $"HBoxContainer/StatsSummary/Alcohol".value
	print("He enviado la señal just_attacked")
	emit_signal("just_attacked", "Armada", "Esto no es na'", "", "[wave] ¡Este hijo de puta quiere emborracharse![/wave]")

func atk4():
	#¿Un lolete?
	#Armada va tan borracho que se piensa que está en la grieta del invocador y se abalanza
	#contra un pceomón enemigo, comenzando a meterle de ostias y rociarle alcohol tóxico lo cual infiere
	#daño físico y mucho daño químico. Además si el enemigo tiene el 20% de la vida o menos, le oneshotea.
	var attacked = foes[rng.randi_range(0,foes.size()-1)]
	if float(attacked.actual_hp)/attacked.max_hp <= 0.2:
		attacked.damage(attacked.max_hp)
	else:
		foes[rng.randi_range(0,foes.size()-1)].damage(1000)
	$"HBoxContainer/StatsSummary/Alcohol".value = $"HBoxContainer/StatsSummary/Alcohol".value - 90
	alcohol = $"HBoxContainer/StatsSummary/Alcohol".value
	emit_signal("just_attacked", "Armada", "¿Un lolete?", attacked.name, "Se pensaba que era [shake]un minion de la grieta[/shake]")
