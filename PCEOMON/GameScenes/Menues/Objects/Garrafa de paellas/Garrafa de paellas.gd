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
	#NO SE COMO SE HACE LA COMPROBACION DE TIPOS JAJASALU2
#	if target.get_type() == "res://PCEOMONES_classes/Alcoholic.gd":
#		target.alcohol += GARRAFA_ALCOHOL
#	else:
	target.poison([target], DAMAGE_VENENO)
	emit_signal("announcement","Sabe demasiado a alcochol, pero eso no tiene por qué ser algo malo.")
	#FALTA HACER QUE BAJE LA VELOCIDAD


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
