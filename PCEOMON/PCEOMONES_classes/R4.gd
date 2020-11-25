extends "res://PCEOMON_combat.gd"

signal dimension_changed(pceomon, trapped)
signal release_pceomon(pceomon,releaser)

func ready():
	metadata.dimensions[self.name] = []
	.ready()

func select_combat_dimension(var message : String, var target, var dimension):
	if target == ALLY:
		if mates != []:
			emit_signal("permanent_announcement", message)
			targets.append(yield(select_dimension(ALLY, dimension), "completed"))
		else:
			emit_signal("announcement", "No hay aliados para seleccionar")
			next_attack_required_stamina = 1
	elif target == ENEMY:
		if foes != []:
			emit_signal("permanent_announcement", message)
			targets.append(yield(select_dimension(ENEMY, dimension), "completed"))
		else:
			emit_signal("announcement", "No hay enemigos para seleccionar")
			next_attack_required_stamina = 1
	elif target == BOTH:
		if foes != [] or mates != []:
			emit_signal("permanent_announcement", message)
			targets.append(yield(select_dimension(BOTH, dimension), "completed"))
		else:
			emit_signal("announcement", "No hay aliados ni enemigos para seleccionar")
			
func select_dimension(var identity, var dimension):
	target = 0
	selecting = true
	select_candidates = []
	if identity == ALLY:
		select_candidates += metadata.dimensions[dimension] #SI HACES ESTO, GODOT LE AÑADE AL PRIMER ARRAY
		#LOS ELEMENTOS DEL SEGUNDO, RE LOCO MI REY
		select_candidates -= foes
		select_candidates.erase(self)
		select_candidates[target].arrow.visible = true
		print("Seleccionando aliado")
		yield(self, "target_selected")
		select_candidates[target].arrow.visible = false
		selecting = false
		return select_candidates[target]
	elif identity == ENEMY:
		print("Seleccionando enemigo")
		select_candidates += metadata.dimensions[dimension]
		select_candidates -= mates
		select_candidates.erase(self)
		select_candidates[target].arrow.visible = true
		yield(self, "target_selected")
		select_candidates[target].arrow.visible = false
		selecting = false
		return select_candidates[target]
	else:
		print("Seleccionando lo que me salga de los cojones")
		select_candidates += metadata.dimensions[dimension]
		select_candidates.erase(self)
		select_candidates[target].arrow.visible = true
		yield(self, "target_selected")
		select_candidates[target].arrow.visible = false
		selecting = false
		return select_candidates[target]


func trap(pceomon):
	if pceomon.type == "R4":
		emit_signal("announcement","¡No puedes encerrar a un R4!")
		return false
	emit_signal("dimension_changed",self.name, pceomon)
	return true

func release(pceomon):
	 emit_signal("release_pceomon",self.name, pceomon)

