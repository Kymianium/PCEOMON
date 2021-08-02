extends Control

var item_map = {}

signal announcement(message)

const BOCATA_HEAL = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	item_map["Bocata"] = funcref(self,"bocata")

func get_func_from_name(name):
	if item_map[name] != null:
		return item_map[name]
	print("MUERTE Y DESTRUCCION EN ObjectManager: Objecto no incluido en el mapa de Items")

func bocata(target):
	print("bocata")
	target.heal([target],BOCATA_HEAL)
	emit_signal("announcement","Qué rico el bocata de la cantina de Economía antes de subir a paellas.")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
