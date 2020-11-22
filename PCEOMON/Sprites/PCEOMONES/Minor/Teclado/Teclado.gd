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
	for enemy in foes:
		enemy.connect("attacked",self,"enemy_attacked")


func enemy_attacked(attacker, attacked, damage, type):
	self.damage = damage
	self.attacked = attacked


func next1():
	next_attack_required_stamina = 400
	.next1()

func next2():
	next_attack_required_stamina = 500
	emit_signal("permanent_announcement", "Selecciona a un PCEOMÓN para [shake]copiarle el ataque[/shake]")
	selected_both = yield(select(BOTH), "completed")
	.next2()

func next3():
	if (tipo_robado == null):
		emit_signal("announcement","¡Roba primero un ataque!")
		return
	elif tipo_robado == "Alcohólico":
		emit_signal("permanent_announcement", "[wave]Ugh, no voy muy bien.\n¡Hombre, pero si es ...[/wave]")
		selected_enemy = yield(select(ENEMY), "completed")
	elif tipo_robado == "Programador":
		emit_signal("permanent_announcement","Selecciona al aliado que quieras [tornado]potenciar[/tornado].")
		selected_ally = yield(select(ALLY), "completed")
	elif tipo_robado == "Gym":
		emit_signal("permanent_announcement","ESTOY HIPERTRÓFICO")
		selected_enemy = yield(select(ENEMY), "completed")
	elif tipo_robado == "R4":
		emit_signal("permanent_announcement","Ahora veo todo desde una nueva perspectiva, mejor protejo a...")
		selected_ally = yield(select(ALLY), "completed")
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
		for i in range(attacked.size()):
			attacked[i].heal(damage[i])
		emit_signal("just_attacked",self.name,"Ctrl+Z","","Aquí no ha pasado nada...")
		emit_signal("healed",self,attacked,damage)
		damage = null
		attacked = null
	else:
		emit_signal("just_attacked",self.name,"Ctrl+Z","","¡Pero no había nada que deshacer!")
	


func atk2():
	tipo_robado = selected_both.type

func atk3():
	if tipo_robado == "Alcohólico":
		var damage_done = make_damage(selected_enemy,200,1,CHEMICAL_DMG)
		unicast_damage(damage_done,selected_enemy.name,"Ctrl+V","Control+Pota")
		emit_signal("attacked",self,[selected_enemy],[damage_done],CHEMICAL_DMG)
	elif tipo_robado == "Programador":
		var tipoataque = rng.randi()%3
		var tipo
		if tipoataque == 0:
			tipo = CHEMICAL_DMG
		elif tipoataque == 1:
			tipo = PHYSICAL_DMG
		elif tipoataque == 2:
			tipo = PSYCHOLOGYCAL_DMG
		selected_ally.buff(tipo,2000,1.2,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","NO COMPILA")
		emit_signal("buffed", self, [selected_ally], tipo)
	elif tipo_robado == "Menor":
		for ally in mates:
			ally.heal(calculate_chemical_damage(80,0.2))
		emit_signal("just_attacked",self.name,"Ctrl+V","","Cuídense mis panas")
		var healed = []
		for mate in mates:			##ESTA COLOCADA ES PARA QUE SE HAGA UNA LISTA CON LA MISMA LONG QUE MATES
			healed.append(calculate_chemical_damage(80,0.2))
		emit_signal("healed", self, [mates], healed)
	elif tipo_robado == "Gym":
		var damage_done =  make_damage(selected_enemy,200,1,PHYSICAL_DMG)
		unicast_damage(damage_done,selected_enemy.name,"Ctrl+V","Te copio y te pego")
		emit_signal("attacked", self, [selected_enemy], [damage_done], PHYSICAL_DMG)
	elif tipo_robado == "R4":
		var tipodef = rng.randi() % 3
		var defensa
		if tipodef == 0:
			defensa = CHEMICAL_DFC
		elif tipodef == 1:
			defensa = PHYSICAL_DFC
		elif tipodef == 2:
			defensa = PSYCHOLOGYCAL_DFC
		selected_ally.buff(defensa,2000,1.2,0)
		emit_signal("just_attacked",self.name,"Ctrl+V","","Una dimensión más, [shake level=10]poder infinito[/shake]")
		emit_signal("buffed", self, [selected_ally], defensa)
	elif tipo_robado == "Ceronaturalista":
		for enemy in foes:
			enemy.buff(EVASION,2000,1.5,0)
		for ally in mates:
			ally.buff(EVASION,2000,1.5,0)
		self.buff(EVASION,2000,1.5,0)
		emit_signal("buffed", self, [foes, mates, self], EVASION)
		emit_signal("just_attacked",self.name,"Ctrl+V","","Ahora nadie tiene una velocidad natural")
	elif false:
		pass



