extends "res://PCEOMONES_classes/PCEOMON.gd"


var peaceful:bool = false
var selected_mate = null


func _ready():
	arrow = $Arrow
	name = "Alparko"
	ability = "Peaceful mode"
	attack1 = "/tp"
	attack2 = "Aspecto Ígneo"
	attack3 = "/timeset day"
	attack4 = "/weather clear"
	._ready()
	max_hp = 1000
	actual_hp = max_hp
	avatar_path = "res://Sprites/PCEOMONES/Major/Alparko/Alparko_avatar.png"
	next_attack_required_stamina = 1000

func next1():
	next_attack_required_stamina = 200
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN al que quieres hacer tp")
	selected_mate = yield(select(true), "completed")
	.next1()

func next2():
	next_attack_required_stamina = 200
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN [color=<red>]ígneo[/color]")
	selected_mate = yield(select(true), "completed")
	.next2()

func next3():
	next_attack_required_stamina = 300
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN al que quieres proteger")
	selected_mate = yield(select(true), "completed")
	.next3()

func next4():
	next_attack_required_stamina = 300
	.next4()




func damage(var damage:int):
	if (not peaceful):
		.damage(damage)


func atk1():
	foes[rng.randi_range(0,foes.size()-1)].damage(200)

func atk2():
	mates[rng.randi_range(0,mates.size()-1)].buff()
