extends Control


var item_map = {}
var Fiumer		#clase preimportada para comprobar si un PCEOMON es de este tipo
var Alcoholic

const CHEMICAL_DMG = 0
const PHYSICAL_DMG = 1
const PSYCHOLOGYCAL_DMG = 2
const TRUE_DMG = 3
const CHEMICAL_DFC = 4
const PHYSICAL_DFC = 5
const PSYCHOLOGYCAL_DFC = 6
const SPEED = 7
const EVASION = 8
const STUN = 9
const POISON = 10
const SHIELD = 11
const SLEEP = 12


signal announcement(message)

const BOCATA_HEAL = 200
const SHOWER_DAMAGE = 100
const MACARRAS_HEAL = 400
const MACARRAS_SPEED_DEBUFF = 0.5
const GARRAFA_DAMAGE = 300
const MONSTER_SPEED_BUFF = 2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Fiumer = preload("res://PCEOMONES_classes/FIUMER.gd")
	Alcoholic = preload("res://PCEOMONES_classes/Alcoholic.gd")
	item_map["Bocata"] = funcref(self,"bocata")
	item_map["Ducha bluetooth"] = funcref(self,"ducha")
	item_map["Fuente de macarras"] = funcref(self,"macarras")
	item_map["Garrafa de paellas"] = funcref(self,"garrafa")
	item_map["Monster"] = funcref(self,"monster")
	item_map["Pulsera del Murcia"] = funcref(self,"pulsera_murcia")

func get_func_from_name(name):
	if name in item_map:
		return item_map[name]
	print("MUERTE Y DESTRUCCION EN ObjectManager: Objecto no incluido en el mapa de Items")

func bocata(target):
	print("bocata")
	target.heal([target],BOCATA_HEAL)
	emit_signal("announcement","Qué rico el bocata de la cantina de Economía antes de subir a paellas.")

func ducha(target):
	if target is Fiumer:
		emit_signal("announcement","¿Agua que cae del techo? [shake]¿Qué es esto?[/shake]")
		target.take_chemical_damage(SHOWER_DAMAGE)
	else:	#TODO testear cuando algun enemigo meta cambios de estado
		emit_signal("announcement","¡Los cambios de estado de " + target.name + " han desaparecido!")
		target.clear_states()
	

func macarras(target):
	target.heal([target],MACARRAS_HEAL)
	target.buff([target], SPEED, 1500, MACARRAS_SPEED_DEBUFF, 0)
	emit_signal("announcement","Una fuente entre clase y clase entra bastante bien.")

func garrafa(target):
	if target is Alcoholic:
		target.alcohol = target.maxalcohol
		emit_signal("announcement","Placeholder")#TODO no se me ocurre nada
	else:
		target.poison([target], GARRAFA_DAMAGE)
		emit_signal("announcement","No ha terminado de sentar bien el vodka de 4 euros...")

func pulsera_murcia(target):
	if target.name != "Mafranpe":
		emit_signal("announcement",target.name + " se ha comprado la pulsera del Murcia. Mafranpe estaría orgulloso.")
	else:
		emit_signal("announcement",target.name + " se ha comprado la pulsera del Murcia y se ha puesto a dar la chapa para que te la compres tú también.")
		

func monster(target):
	target.buff([target], SPEED, 1500, MONSTER_SPEED_BUFF, 0)
	emit_signal("announcement","Placeholder")#TODO no se me ocurre nada
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
