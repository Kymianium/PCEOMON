extends Control


const BOCATA_HEAL = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_func_from_name(name):
	if name == "Bocata":
		return funcref(self,"bocata")			#Guarda la funcion como variable, para llamarla usar var.call_func()
	return

func bocata(target):
	target.heal([target],BOCATA_HEAL)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
