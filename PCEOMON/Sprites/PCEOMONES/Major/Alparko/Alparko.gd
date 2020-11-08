extends "res://PCEOMON_combat.gd"

var rng = RandomNumberGenerator.new()
var peaceful:bool = false

func _ready():
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


func damage(var damage:int):
	if (not peaceful):
		.damage(damage)


func atk1():
	foes[rng.randi_range(0,foes.size()-1)].damage(200)
	end_attack()
	pass
