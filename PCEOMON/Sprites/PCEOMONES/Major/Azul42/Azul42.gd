extends "res://PCEOMONES_classes/ZeroNaturalist.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hijoputismo:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/StatsSummary/Shield.value = 0
	name = "Azul42"
	ability = "No-ceronaturalista/Residencia"
	attack1 = "Trigo"
	attack2 = "No ayudar con PCEOMON"
	attack3 = "No ganar El Juego"
	attack4 = "Ser un hijo de puta"
	type = "CeroNaturalista"
#	dimension.append("Paco")
	#if not dimension.has(null):
	#	dimension.append(null)
	#print("lista paco = " + str(dimension))
	._ready()
	att2name = "No ayudar"			#ESTA ES LA FORMA DE ACORTAR NOMBRES EN LA INTERFAZ. SIEMPRE DESPUES DE LLAMAR AL READY DEL PADRE
	avatar_path = "res://Sprites/PCEOMONES/Major/Azul42/Azul42_avatar.png"

func next1():
	next_attack_required_stamina = 200
	.next1()

func next2():
	next_attack_required_stamina = 40
	.next2()

func next3():
	next_attack_required_stamina = 500
	.next3()

func next4():
	next_attack_required_stamina = 300
	.next4()

func atk1():
	targets = [self]
	targets += mates
	targets += foes
	buff(targets, EVASION , 5000, 0.7, 0)
	if !(hijoputismo):
		emit_signal("announcement","Azul42 ha disminuido la precisión de todos los PCEOMONES. ¡Qué hijo de puta, a por él!")
		take_physical_damage(200)
	else:
		emit_signal("announcement","Azul42 ha disminuido la precisión de todos los PCEOMONES. Es un hijo de puta, pero es nuestro hijo de puta.")
		hijoputismo = true
	$"SpriteContainer/AnimatedSprite".animation = "trigo"
	$"SpriteContainer/Manjarito".animation = "trigo"
	emit_signal("camera_zoom",self)
	.atk1()
	
func atk2():
	emit_signal("announcement","Se esperaba un movimiento muy poderoso, pero Azul no lo ha programado")
	$"SpriteContainer/AnimatedSprite".animation = "no_ayudar"
	$"SpriteContainer/Manjarito".animation = "no_ayudar"
	emit_signal("camera_zoom",self)
	.atk2()

func atk3():
	for mat in mates:
		mat.set_stamina(1)
	for foe in foes:
		foe.set_stamina(1)
	if !(hijoputismo):
		emit_signal("announcement","Azul ha gritado \"He perdido\" y todo el mundo ha perdido la concentración. ¡Qué hijo de puta, a por él!")
		take_physical_damage(200)
	else:
		emit_signal("announcement","Azul ha gritado \"He perdido\" y todo el mundo ha perdido la concentración. Es un hijo de puta, pero esta se la pasamos.")
		hijoputismo = true
	$"SpriteContainer/AnimatedSprite".animation = "perder"
	$"SpriteContainer/Manjarito".animation = "perder"
	emit_signal("camera_zoom",self)
	.atk3()

func atk4():
	hijoputismo = true
	emit_signal("just_attacked",self.name, "hijoputismo", "","\"Decid todo lo que queráis, pero no me podéis echar del grupo de clase\"")
	#emit_signal("announcement","Azul se ha cubierto de un manto de hijoputismo. \"Decid todo lo que queráis, pero no me podéis echar del grupo de clase\".")
	$"SpriteContainer/AnimatedSprite".animation = "hijo_puta"
	$"SpriteContainer/Manjarito".animation = "hijo_puta"
	emit_signal("camera_zoom",self)
	.atk4()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Manjarito_animation_finished():
	$SpriteContainer/Manjarito.animation = "default"
