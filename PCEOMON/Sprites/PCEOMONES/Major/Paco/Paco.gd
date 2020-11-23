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
#	dimension.append("Paco")
	#if not dimension.has(null):
	#	dimension.append(null)
	#print("lista paco = " + str(dimension))
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Major/Paco/Paco_avatar.png"

func next1():
	next_attack_required_stamina = 300
	select_combat("Selecciona un PCEOMON que esté en Orihuela", BOTH)
	.next1()

func next2():
	next_attack_required_stamina = 300
	select_combat("Selecciona un PCEOMON que no esté en Orihuela", BOTH)
	.next2()
func next3():
	next_attack_required_stamina = 800
	.next3()


func atk1():
	release(selected_foe)
	emit_signal("just_attacked","Paco","Es hora de marchar",selected_both.name,"Paco ha abandonado a su suerte a " + selected_both.name)

func atk2():
	trap(selected_foe)
	emit_signal("just_attacked","Paco","Inundar",selected_both.name,"Un torrente de agua arrastra a " + selected_both.name + " a las profundidas de [tornado]Orihuela[/tornado]")

func atk3():
	emit_signal("just_attacked","nada","","","")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
