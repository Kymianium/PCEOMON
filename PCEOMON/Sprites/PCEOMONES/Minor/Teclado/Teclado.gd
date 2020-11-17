extends "res://PCEOMONES_classes/MINOR.gd"

var tipo_robado = null
var selected_enemy
var selected_ally

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

func next1():
	emit_signal("announcement","Ataque no implementado")

func next2():
	next_attack_required_stamina = 500
	emit_signal("permanent_announcement", "Selecciona a un PCEOMÓN para [shake]copiarle el ataque[/shake]")
	selected_enemy = yield(select(true), "completed")
	.next2()

func next3():
	if (tipo_robado == null):
		emit_signal("announcement","¡Roba primero un ataque!")
		return
	elif tipo_robado == "Alcohólico":
		emit_signal("permanent_announcement", "[wave]Ugh, no voy muy bien.\n¡Hombre, pero si es ...[/wave]")
		selected_enemy = yield(select(false), "completed")
	elif tipo_robado == "Programador":
		emit_signal("permanent_announcement","Selecciona al aliado que quieras [tornado]potenciar[/tornado].")
		selected_enemy = yield(select(false), "completed")
	elif tipo_robado == "Gym":
		emit_signal("permanent_announcement","ESTOY HIPERTRÓFICO")
		selected_enemy = yield(select(false), "completed")
	elif tipo_robado == "R4":
		emit_signal("permanent_announcement","Ahora veo todo desde una nueva perspectiva, mejor protejo a...")
		selected_ally = yield(select(true), "completed")
	next_attack_required_stamina = 200
	.next3()
		
func next4():
	next_attack_required_stamina = 600
	.next4()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func atk2():
	tipo_robado = selected_enemy.type

func atk3():
	if tipo_robado == "Alcohólico":
		var damage_done = selected_enemy.take_chemical_damage(calculate_chemical_damage(200, 1))
		unicast_damage(damage_done,selected_enemy.name,"Ctrl+V","Control+Pota")
	elif tipo_robado == "Programador":
		var tipoataque = rng.randi(2)
		if tipoataque == 0:
			selected_ally.buff("chemicaldmg",2000,1.2,0)
		elif tipoataque == 1:
			selected_ally.buff("physicaldmg",2000,1.2,0)
		elif tipoataque == 2:
			selected_ally.buff("psychologycaldmg",2000,1.2,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","NO COMPILA")
	elif tipo_robado == "Menor":
		for ally in mates:
			ally.heal(100)
		emit_signal("just_attacked",self.name,"Ctrl+V","","Cuídense mis panas")
	elif tipo_robado == "Gym":
		var damage_done = selected_enemy.take_physical_damage(calculate_chemical_damage(200, 1))
		unicast_damage(damage_done,selected_enemy.name,"Ctrl+V","Te copio y te pego")
	elif tipo_robado == "R4":
		var tipodef = rng.randi(2)
		if tipodef == 0:
			selected_ally.buff("chemicaldfc",2000,1.2,0)
		elif tipodef == 1:
			selected_ally.buff("physicaldfc",2000,1.2,0)
		elif tipodef == 2:
			selected_ally.buff("psychologycaldfc",2000,1.2,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","Una dimensión más, [shake level=10]poder infinito[/shake]")
	elif tipo_robado == "Ceronaturalista":
		for enemy in foes:
			enemy.buff("speed",2000,1.5,0)
		for ally in mates:
			ally.buff("speed",2000,1.5,0)
		self.buff("speed",2000,1.5,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","Ahora nadie tiene una velocidad natural")
	elif false:
		pass



