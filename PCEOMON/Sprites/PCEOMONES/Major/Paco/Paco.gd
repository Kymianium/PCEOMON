extends "res://PCEOMONES_classes/R4.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/StatsSummary/Shield.value = 0
	arrow = $Arrow
	name = "Paco"
	ability = "Oriolano"
	attack1 = "Hora de marchar"
	attack2 = "Inundar"
	attack3 = "F por Álgebra"
	attack4 = "No hacer jal"
	type = "R4"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Major/Paco/Paco_avatar.png"

func next1():
	next_attack_required_stamina = 300
	selected_foe = yield(select(false), "completed")
	while (not selected_foe.dimension.has("Paco")):
		emit_signal("announcement","Selecciona un PCEOMON que no esté en Orihuela")
		selected_foe = yield(select(false), "completed")
	.next1()

func next2():
	next_attack_required_stamina = 300
	selected_foe = yield(select(false), "completed")
	while (selected_foe.dimension.has("Paco")):
		emit_signal("announcement","Selecciona un PCEOMON que esté en Orihuela")
		selected_foe = yield(select(false), "completed")
	.next2()


func atk1():
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
