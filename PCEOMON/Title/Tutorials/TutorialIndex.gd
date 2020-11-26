extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current
var increasing_value = 0
var delta_accumulated = 0
var type_string
var type_index = 0

var types_icon = []
var types_example = []
var types_text = []

# Called when the node enters the scene tree for the first time.
func _ready():
	current = $TutorialsAndText/Tutorial/Text
	
	#ALCOHÓLICO
	types_icon.append(load("res://Sprites/Miscelaneous/Types/Alcoholic.png"))
	types_example.append(load("res://Sprites/PCEOMONES/Major/Armada/Armada_avatar.png"))
	type_string = """
		El tipo alcohólico se centra en ataques devastadores y muy veloces, sacrificando a cambio una 'moneda de cambio'. Un alcohólico tan sólo podrá atacar si tiene el suficiente alcohol en sangre.
	
	+ Buen daño
	+ Veloces
	- Frágiles
	"""
	types_text.append(type_string)
	#R4
	types_icon.append(load("res://Sprites/Miscelaneous/Types/R4.png"))
	types_example.append(load("res://Sprites/PCEOMONES/Major/Paco/Paco_avatar.png"))
	type_string = """
		Los R4 poseen un arma secreta: una nueva dimensión. Son capaces de aguantar grandes cantidades de daño y de 'encerrar' PCEOMONES en dimensiones donde no son alcanzables por otros PCEOMONES.
	
	+ Mucha defensa
	+ Dimensión extra
	- Lentos
	- Poco daño
	"""
	types_text.append(type_string)
	#Gym
	types_icon.append(load("res://Sprites/Miscelaneous/Types/Gym.png"))
	types_example.append(load("res://Sprites/PCEOMONES/Major/Chito/Chito_avatar.png"))
	type_string = """
		Los PCEOMONES Gym seleccionan un enemigo y lo golpean de manera pasiva a lo largo del combate. Generalmente, sus ataques potencian este 'ataque pasivo'. Su medidor de Ira determina cuánto daño hará y cada cuanto tiempo.
	
	+ Fuente de daño permanente
	+ Moderadamente resistentes
	- Faciles de contraarrestar
	- Velocidad mediocre
	"""
	types_text.append(type_string)
	#Programador
	types_icon.append(load("res://Sprites/Miscelaneous/Types/Programmer.png"))
	types_example.append(load("res://Sprites/PCEOMONES/Major/Alparko/Alparko_avatar.png"))
	type_string = """
		Un programador apoyará al equipo, aumentando las estadísticas de sus compañeros de equipo y disminuyendo las de sus adversarios.
	
	+ Buen apoyo
	+ Hace tu equipo más poderoso con el tiempo
	- Poco daño
	"""
	types_text.append(type_string)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_accumulated+=delta
	if delta_accumulated>=0.1:
		delta_accumulated-=0.1
		increasing_value = (increasing_value + 1) % 100
	#COMBAT
	$TutorialsAndText/Tutorial/Combat/VerticalContainter/PCEOMONES/HP.value = 100 - increasing_value
	$TutorialsAndText/Tutorial/Combat/VerticalContainter/PCEOMONES/Stamina.value = (increasing_value%50)*2
	$TutorialsAndText/Tutorial/Combat/VerticalContainter/PCEOMONES/Alcohol.value = (increasing_value%25)*4
func _on_Exit_pressed():
	get_tree().change_scene("res://Title/TitleScreen.tscn")


func _on_Combat_pressed():
	current.visible = false
	current = $TutorialsAndText/Tutorial/Combat
	current.visible = true


func _on_Attacks_pressed():
	current.visible = false
	current = $TutorialsAndText/Tutorial/AttacksAbilities
	current.visible = true


func _on_Types_pressed():
	current.visible = false
	current = $TutorialsAndText/Tutorial/Types
	current.visible = true
	$TutorialsAndText/Tutorial/Types/VerticalContainter/TypeExample/Icon.texture = types_icon[type_index]
	$TutorialsAndText/Tutorial/Types/VerticalContainter/TypeExample/PCEOMON.texture = types_example[type_index]
	$TutorialsAndText/Tutorial/Types/VerticalContainter/Text.text = types_text[type_index]


func _on_Latter_pressed():
	type_index-=1
	if (type_index<0):
		type_index = types_text.size()-1
	$TutorialsAndText/Tutorial/Types/VerticalContainter/TypeExample/Icon.texture = types_icon[type_index]
	$TutorialsAndText/Tutorial/Types/VerticalContainter/TypeExample/PCEOMON.texture = types_example[type_index]
	$TutorialsAndText/Tutorial/Types/VerticalContainter/Text.text = types_text[type_index]

	


func _on_Next_pressed():
	type_index+=1
	type_index= type_index%types_text.size()
	$TutorialsAndText/Tutorial/Types/VerticalContainter/TypeExample/Icon.texture = types_icon[type_index]
	$TutorialsAndText/Tutorial/Types/VerticalContainter/TypeExample/PCEOMON.texture = types_example[type_index]
	$TutorialsAndText/Tutorial/Types/VerticalContainter/Text.text = types_text[type_index]
