extends "res://GameScenes/Menues/Miscelaneous/Item.gd"


const BOCATA_HEAL = 200


# Called when the node enters the scene tree for the first time.

func _ready():
	description = "Cura levemente la vida del PCEOMON seleccionado. Perfecto para un almuerzo rápido y ligero."
	._ready()

func useObject(target):
	target.heal([target],BOCATA_HEAL)
	emit_signal("announcement","Qué rico el bocata de la cantina de Economía antes de subir a paellas.")
