extends "res://PCEOMONES_classes/MINOR.gd"

var tipo_robado = null
var selected_enemy
var selected_ally

##CONTROL + Z
var damage = null
var attacked = null

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "Teclado"
	ability = "Snippet"
	attack1 = "Ctrl+Z"
	attack2 = "Ctrl+C"
	attack3 = "Ctrl+V"
	attack4 = "Ctrl+Alt+Suprimir"
	type = "Menor"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/Teclado/Teclado_avatar.png"
	next_attack_required_stamina = 1300


func new_foe(foe):
	foe.connect("attacked", self, "enemy_attacked")
	.new_foe(foe)


func enemy_attacked(attacker, attacked, damage, type):
	print(attacker.name + " atacó e hizo " + String(damage) + " daño")
	self.damage = damage
	self.attacked = attacked


func next1():
	next_attack_required_stamina = 400
	.next1()

func next2():
	next_attack_required_stamina = 500
#	emit_signal("permanent_announcement", "Selecciona a un PCEOMÓN para [shake]copiarle el ataque[/shake]")
#	targets.append(yield(select(BOTH), "completed"))
	select_combat("Selecciona a un PCEOMÓN para [shake]copiarle el ataque[/shake]",BOTH)
	.next2()

func next3():
	if (tipo_robado == null):
		emit_signal("announcement","¡Roba primero un ataque!")
		return
	elif tipo_robado == "Alcohólico":
#		emit_signal("permanent_announcement", "[wave]Ugh, no voy muy bien.\n¡Hombre, pero si es ...[/wave]")
#		targets.append(yield(select(ENEMY), "completed"))
		select_combat("[wave]Ugh, no voy muy bien.\n¡Hombre, pero si es ...[/wave]",ENEMY)
	elif tipo_robado == "Programador":
#		emit_signal("permanent_announcement","Selecciona al aliado que quieras [tornado]potenciar[/tornado].")
#		targets = yield(select(ALLY), "completed")
		select_combat("Selecciona al aliado que quieras [tornado]potenciar[/tornado].",ALLY)
	elif tipo_robado == "Gym":
#		emit_signal("permanent_announcement","ESTOY HIPERTRÓFICO")
#		targets.append(yield(select(ENEMY), "completed"))
		select_combat("ESTOY HIPERTRÓFICO",ENEMY)
	elif tipo_robado == "R4":
#		emit_signal("permanent_announcement","Ahora veo todo desde una nueva perspectiva, mejor protejo a...")
#		targets.append(yield(select(ALLY), "completed"))
		select_combat("Ahora veo todo desde una nueva perspectiva, mejor protejo a...",ALLY)
	next_attack_required_stamina = 200
	.next3()
		
func next4():
	next_attack_required_stamina = 600
	.next4()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func atk1():
	if (damage != null):
		heal_custom(attacked, damage)
		emit_signal("just_attacked",self.name,"Ctrl+Z","","Aquí no ha pasado nada...")
		damage = null
		attacked = null
	else:
		emit_signal("just_attacked",self.name,"Ctrl+Z","","¡Pero no había nada que deshacer!")
	.atk1()


func atk2():
	tipo_robado = targets[0].type
	emit_signal("just_attacked",self.name,"Ctrl+C","","Espero que no nos pille el algoritmo anti-copia...")
	.atk2()

func atk3():
	if tipo_robado == "Alcohólico":
		unicast_damage(200,0.6, CHEMICAL_DMG, targets,"Ctrl+V","Control+Pota")
	elif tipo_robado == "Programador":
		var tipoataque = rng.randi()%3
		var tipo
		if tipoataque == 0:
			tipo = CHEMICAL_DMG
		elif tipoataque == 1:
			tipo = PHYSICAL_DMG
		elif tipoataque == 2:
			buff(targets, PSYCHOLOGYCAL_DMG,2000,1.2,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","NO COMPILA")
	elif tipo_robado == "Menor":
		heal(mates, calculate_chemical_damage(80,0.2))
		emit_signal("just_attacked",self.name,"Ctrl+V","","Cuídense mis panas")
	elif tipo_robado == "Gym":
		unicast_damage(200, 0.6, PHYSICAL_DMG, targets,"Ctrl+V","Te copio y te pego")
	elif tipo_robado == "R4":
		var tipodef = rng.randi() % 3
		var defensa
		if tipodef == 0:
			defensa = CHEMICAL_DFC
		elif tipodef == 1:
			defensa = PHYSICAL_DFC
		elif tipodef == 2:
			defensa = PSYCHOLOGYCAL_DFC
		buff(targets, defensa,2000,1.2,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","Una dimensión más, [shake level=10]poder infinito[/shake]")
	elif tipo_robado == "Ceronaturalista":
		for enemy in foes:
			enemy.buff(EVASION,2000,1.5,0)
		for ally in mates:
			ally.buff(EVASION,2000,1.5,0)
		buff(self, EVASION,2000,1.5,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","Ahora nadie tiene una velocidad natural")
	.atk3()


