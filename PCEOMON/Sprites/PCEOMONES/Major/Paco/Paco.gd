extends "res://PCEOMONES_classes/R4.gd"


var gotaParticle = "res://Sprites/PCEOMONES/Major/Paco/GotaParticle.tscn"
var jalParticle = "res://Sprites/PCEOMONES/Major/Paco/JalParticle.tscn"
var inundarParticle = "res://Sprites/PCEOMONES/Major/Paco/InundarParticle.tscn"


var hacer_jal_required_stamina
var hacer_jal_stamina 
var hacer_jal_target
var haciendo_jal = false
var delta_acum2 = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/StatsSummary/Shield.value = 0
	arrow = $Arrow
	name = "Paco"
	ability = "Oriolano"
	attack1 = "Hora de marchar"
	attack2 = "Inundar"
	attack3 = "F por Álgebra"
	attack4 = "No hacer jal"
	type = "R4"
#	dimension.append("Paco")
	#if not dimension.has(null):
	#	dimension.append(null)
	#print("lista paco = " + str(dimension))
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Major/Paco/Paco_avatar.png"

func next1():
	next_attack_required_stamina = 300
	if not select_combat_dimension("Selecciona un PCEOMON que esté en Orihuela", BOTH, self.name):
		return
	.next1()

func next2():
	next_attack_required_stamina = 300
	if not select_combat_dimension("Selecciona un PCEOMON que no esté en Orihuela", BOTH, "default"):
		return
	.next2()
func next3():
	next_attack_required_stamina = 800
	.next3()
func next4():
	if !haciendo_jal:
		next_attack_required_stamina = 500 #MODIFICAR
		select_combat("Aquí pongo todos los argumentos y... Y... Joder, se me olvida algo...", ENEMY)
	else:
		next_attack_required_stamina = 1
		emit_signal("announcement", "¡Paco aún no se ha dado cuenta de que no ha hecho el JAL!")
	.next4()


func atk1():
	release(targets[0])
	emit_signal("particle", gotaParticle, targets[0].position.x+60, targets[0].position.y+220)
	emit_signal("just_attacked","Paco","Es hora de marchar",targets[0].name,"Paco ha abandonado a su suerte a " + targets[0].name)
	.atk1()

func atk2():
	trap(targets[0])
	emit_signal("just_attacked","Paco","Inundar",targets[0].name,"Un torrente de agua arrastra a " + targets[0].name + " a las profundidas de [tornado]Orihuela[/tornado]")
	if targets[0].boss:
		emit_signal("particle", inundarParticle, targets[0].position.x+60, targets[0].position.y+100)
	else:
		emit_signal("particle", inundarParticle, targets[0].position.x+30, targets[0].position.y+50)
	emit_signal("camera_zoom",targets[0])
	.atk2()
##################################
## MODIFICAR VALORES DEL ATAQUE ##
##################################
func atk3():
	permanent_buff([self], [PHYSICAL_DFC, PSYCHOLOGYCAL_DFC, CHEMICAL_DFC] , 1.2, 0)
	emit_signal("just_attacked","Paco","F por Algebra","","... ¡Pero F mis putos cojones! ¡PACO SE HA SACADO UN 10!")
	$"SpriteContainer/AnimatedSprite".animation = "f"
	emit_signal("camera_zoom",self)
	.atk3()
##################################
## MODIFICAR VALORES DEL ATAQUE ##
##################################
func atk4():
	if !haciendo_jal:
		hacer_jal_required_stamina = 200#rng.randi() % 1000 + 500 #Numero entre 500 y 1500 (MODIFICAR)
		haciendo_jal = true
		hacer_jal_target = targets[0]
		hacer_jal_stamina = 0
	.atk4()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if haciendo_jal:
		if (hacer_jal_stamina >= hacer_jal_required_stamina):
			unicast_damage(1000,0.3, PSYCHOLOGYCAL_DMG, [hacer_jal_target],"No hacer JAL"," [shake level=10]¡¡¡¡¡¡KA-ME-HA-ME-JAL!!!!!!") #MODIFICAR DAÑOS
			emit_signal("particle", jalParticle, hacer_jal_target.position.x, hacer_jal_target.position.y+150)
			haciendo_jal = false
			hacer_jal_stamina = 0
		elif (metadata.time_should_run()):
			delta_acum2+=delta
			if (delta_acum2>=0.1):
				delta_acum2-=0.1
				hacer_jal_stamina = hacer_jal_stamina + getstat(SPEED)
	._process(delta)

func damage(var damage: int):
	if (rng.randf() < 0.1):
		emit_signal("announcement","¡Esperando el próximo ataque, Paco se ha refugiado en las profundidades del Segura!")
		return 0
	else:
		.damage(damage)
