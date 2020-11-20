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
	dimension.append("Paco")
	if not dimension.has(null):
		dimension.append(null)
	print("lista paco = " + str(dimension))
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
func next3():
	next_attack_required_stamina = 800
	.next3()


func atk1():
	release(selected_foe)
	emit_signal("just_attacked","Paco","Es hora de marchar",selected_foe.name,"Paco ha abandonado a su suerte a " + selected_foe.name)

func atk2():
	trap(selected_foe)
	emit_signal("just_attacked","Paco","Inundar",selected_foe.name,"Un torrente de agua arrastra a " + selected_foe.name + " a las profundidas de [tornado]Orihuela[/tornado]")

func ark3():
	emit_signal("just_attacked","nada","","","")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
