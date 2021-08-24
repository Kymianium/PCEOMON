extends "res://GameScenes/Menues/Miscelaneous/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SHOWER_DAMAGE = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	description = "Limpia efectos de estado y aumenta la defensa química del PCEOMON seleccionado. Si este es un FIUMER le hiere."
	._ready()

func useObject(target):
	if target.type == "Fiumer":
		emit_signal("announcement","¿Agua que cae del techo? [shake]¿Qué es esto?[/shake]")
		target.take_chemical_damage(SHOWER_DAMAGE)
	else:	#TODO testear cuando algun enemigo meta cambios de estado
		emit_signal("announcement","¡Los cambios de estado de " + target.name + " han desaparecido!")
		target.clear_states()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
