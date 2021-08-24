extends "res://GameScenes/Menues/Miscelaneous/Item.gd"



func _ready():
	description = "#SOSREALMURCIA. No hace nada."
	._ready()

func useObject(target):
	emit_signal("announcement","Efectivamente, no hace nada. \n #SOSREALMURCIA")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
