extends "res://PCEOMON_combat.gd"

signal dimension_changed(pceomon, trapped)
signal release_pceomon(pceomon,releaser)

func ready():
	metadata.dimensions[self.name] = []
	.ready()

func trap(pceomon):
	if pceomon.type == "R4":
		emit_signal("announcement","¡No puedes encerrar a un R4!")
		return false
	emit_signal("dimension_changed",self.name, pceomon)
	return true

func release(pceomon):
	 emit_signal("release_pceomon",self.name, pceomon)

