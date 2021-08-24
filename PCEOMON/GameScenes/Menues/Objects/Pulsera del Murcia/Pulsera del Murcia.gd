extends "res://GameScenes/Menues/Miscelaneous/Item.gd"



func _ready():
	description = "#SOSREALMURCIA. No hace nada."
	._ready()

func useObject(target):
	if target.name != "Mafranpe":
		emit_signal("announcement",target.name + " se ha comprado la pulsera del Murcia. Mafranpe estaría orgulloso.")
	else:
		emit_signal("announcement",target.name + " se ha comprado la pulsera del Murcia y se ha puesto a dar la chapa para que te la compres tú también.")
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
