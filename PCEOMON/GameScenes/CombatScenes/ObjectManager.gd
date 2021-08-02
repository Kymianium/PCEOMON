extends Control


var item_map = {}
var Fiumer		#clase preimportada para comprobar si un PCEOMON es de este tipo

signal announcement(message)

const BOCATA_HEAL = 200
const SHOWER_DAMAGE = 400

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Fiumer = preload("res://PCEOMONES_classes/FIUMER.gd")
	item_map["Bocata"] = funcref(self,"bocata")
	item_map["Ducha bluetooth"] = funcref(self,"ducha")

func get_func_from_name(name):
	if item_map[name] != null:
		return item_map[name]
	print("MUERTE Y DESTRUCCION EN ObjectManager: Objecto no incluido en el mapa de Items")

func bocata(target):
	print("bocata")
	target.heal([target],BOCATA_HEAL)
	emit_signal("announcement","Qué rico el bocata de la cantina de Economía antes de subir a paellas.")

func ducha(target):
	if target is Fiumer:	#TODO comprobar que esto funcione cuando se implemente un Fiumer
		emit_signal("announcement","¿Agua que cae del techo? [shake]¿?[/shake]")
		target.take_chemical_damage(SHOWER_DAMAGE)
	else:
		emit_signal("announcement","¡Los cambios de estado de " + target + " desaparecen!")
		target.stun_counter = 0
		$HBoxContainer/Status/Confusion.visible = false
		$HBoxContainer/Status/Sleep.visible = false
		target.poison_counter = 0
		$"HBoxContainer/Status/Poison".visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
