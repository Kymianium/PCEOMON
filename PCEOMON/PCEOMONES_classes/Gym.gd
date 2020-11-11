extends "res://PCEOMON_combat.gd"

func select_enemy():
	emit_signal("permanent_announcement", "¡Selecciona un objetivo!")
	selected_foe = yield(select(false), "completed")
	


func _process(delta):
	._process(delta)
	if(selected_foe==null):
		select_enemy()
