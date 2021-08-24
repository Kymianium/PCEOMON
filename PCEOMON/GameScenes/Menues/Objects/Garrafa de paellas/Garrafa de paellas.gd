extends "res://GameScenes/Menues/Miscelaneous/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const GARRAFA_ALCOHOL = 300
const DAMAGE_VENENO = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	description = "Aumenta el alcohol en sangre del PCEOMON seleccionado. Si este no es de tipo alcohólico le envenena."
	._ready()

func useObject(target):
	if target.type == "Alcóholico":
		target.alcohol += GARRAFA_ALCOHOL
		emit_signal("announcement","Esta garrafa contiene: ginebra, fanta, ácido de batería, silicio, zinc, cromos de pokémon del 98 y/o pepperoni... Y apuntes de funciones.")
	else:
		target.poison([target], DAMAGE_VENENO)
		emit_signal("announcement","No ha terminado de sentar bien el vodka de 4 euros...")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
