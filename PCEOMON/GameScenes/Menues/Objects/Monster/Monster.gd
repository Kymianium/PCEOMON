extends "res://GameScenes/Menues/Miscelaneous/Item.gd"


const MONSTER_SPEED_BUFF = 1.5

func _ready():
	description = "Aumenta la velocidad del PCEOMON seleccionado."
	._ready()

func useObject(target):
	#7 Es la estadistica velocidad
	target.buff([target], 7, 1000, MONSTER_SPEED_BUFF, 0)
	emit_signal("announcement","Corro que me las pelo y viceversa.")
	#FALTA HACER QUE BAJE LA VELOCIDAD


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
