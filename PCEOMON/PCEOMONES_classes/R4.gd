extends "res://PCEOMON_combat.gd"

signal dimension_changed(pceomon)
signal release_pceomon(pceomon,releaser)

func ready():
	dimension.append(name)
	.ready()

func trap(pceomon):
	var new_foes = []
	var new_mates = []
	# TO DO cambiar las dimensiones
	for enemy in pceomon.foes:
		if enemy.dimension.has(name):
			new_foes.append(enemy)
	for ally in pceomon.mates:
		if ally.dimension.has(name):
			new_mates.append(ally)
	pceomon.mates = new_mates
	pceomon.foes = new_foes
	pceomon.dimension.erase(null)
	pceomon.dimension.append(name)
	#print("Hemos cambiado de dim y ha quedado como " + str(pceomon.mates) + str(pceomon.foes))
	emit_signal("dimension_changed",self)

func release(pceomon):
	 emit_signal("release_pceomon",pceomon,self)

