extends "res://PCEOMON_combat.gd"

func _ready():
	arrow = $Arrow
	$HBoxContainer/StatsSummary/Shield.value = 0
	._ready()
