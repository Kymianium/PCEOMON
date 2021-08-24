extends "res://GameScenes/Menues/Miscelaneous/Item.gd"


const MACARRAS_HEAL = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	description = "Cura y baja la velocidad del PCEOMON seleccionado."
	._ready()

func useObject(target):
	target.heal([target],MACARRAS_HEAL)
	target.buff([target], 7, 1000, 1, -2)
	emit_signal("announcement","Tremenda fuente de macarras me acabo de almorzar, me pregunto que habrá para comer.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
