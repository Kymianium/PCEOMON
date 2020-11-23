extends "res://PCEOMONES_classes/R4.gd"


var peaceful : bool = false


func _ready():
	arrow = $Arrow
	name = "Alparko"
	ability = "Peaceful mode"
	attack1 = "/kill"
	attack2 = "Aspecto Ígneo"
	attack3 = "Protección"
	attack4 = "/weather clear"
	type = "Programador"
	._ready()
	max_hp = 1000
	actual_hp = max_hp
	avatar_path = "res://Sprites/PCEOMONES/Major/Alparko/Alparko_avatar.png"
	next_attack_required_stamina = 1000

func next1():
	next_attack_required_stamina = 500
	yield(select_combat("Selecciona al PCEOMÓN al que quieres hacer /kill",ENEMY), "completed")
	.next1()

func next2():
	next_attack_required_stamina = 200
	yield(select_combat("Selecciona al PCEOMÓN [tornado]ÍGNEO.[/tornado]",ALLY), "completed")
	.next2()

func next3():
	next_attack_required_stamina = 300
	yield(select_combat("Selecciona al PCEOMÓN al que quieres proteger", ALLY), "completed")
	.next3()

func next4():
	next_attack_required_stamina = 300
	.next4()




func damage(var damage:int):
	if (not peaceful):
		.damage(damage)
	else:
		 return 0


func atk1():
	var chance = rng.randi() % 500
	var damage_done
	if (chance==69):
		unicast_damage(targets[0].max_hp,0, TRUE_DMG, targets,"/kill","[shake level = 20] ¡A TU CASA, GORDA PUTA![/shake]")
		return
	unicast_damage(300,0.3, PSYCHOLOGYCAL_DMG, targets,"/kill","¡OOF, ESO ESTUVO CERCA!")
	
func atk2():
	permanent_buff(target[0], PHYSICAL_DMG, 1.2, 0)
	emit_signal("just_attacked", "Alparko", "Aspecto Ígneo", "", "Ahora " + targets[0].name + " es  [tornado]ÍGNEO.[/tornado]")
	

func atk3():
	permanent_buff(targets[0], [PHYSICAL_DFC, CHEMICAL_DFC, PSYCHOLOGYCAL_DFC], 1.1, 0)
	emit_signal("just_attacked", "Alparko", "Protección", "", "¡" + targets[0].name + " tiene una piel de hierro!")
	
func atk4():
	for pceomon in mates:
		for buff in pceomon.buffs:
			buff[0] = 0
		pceomon.stats[CHEMICAL_DMG][2]=0
		pceomon.stats[CHEMICAL_DMG][3]=1
		pceomon.stats[PHYSICAL_DMG][2]=0
		pceomon.stats[PHYSICAL_DMG][3]=1
		pceomon.stats[PSYCHOLOGYCAL_DMG][2]=0
		pceomon.stats[PSYCHOLOGYCAL_DMG][3]=1
		pceomon.stats[CHEMICAL_DFC][2]=0
		pceomon.stats[CHEMICAL_DFC][3]=1
		pceomon.stats[PHYSICAL_DFC][2]=0
		pceomon.stats[PHYSICAL_DFC][3]=1
		pceomon.stats[PSYCHOLOGYCAL_DFC][2]=0
		pceomon.stats[PSYCHOLOGYCAL_DFC][3]=1
		pceomon.stats[SPEED][2]=0
		pceomon.stats[SPEED][3]=1
		pceomon.stats[EVASION][2]=0
		pceomon.stats[EVASION][3]=1
	for pceomon in foes:
		for buff in pceomon.buffs:
			buff[0] = 0
		pceomon.stats[CHEMICAL_DMG][2]=0
		pceomon.stats[CHEMICAL_DMG][3]=1
		pceomon.stats[PHYSICAL_DMG][2]=0
		pceomon.stats[PHYSICAL_DMG][3]=1
		pceomon.stats[PSYCHOLOGYCAL_DMG][2]=0
		pceomon.stats[PSYCHOLOGYCAL_DMG][3]=1
		pceomon.stats[CHEMICAL_DFC][2]=0
		pceomon.stats[CHEMICAL_DFC][3]=1
		pceomon.stats[PHYSICAL_DFC][2]=0
		pceomon.stats[PHYSICAL_DFC][3]=1
		pceomon.stats[PSYCHOLOGYCAL_DFC][2]=0
		pceomon.stats[PSYCHOLOGYCAL_DFC][3]=1
		pceomon.stats[SPEED][2]=0
		pceomon.stats[SPEED][3]=1
		pceomon.stats[EVASION][2]=0
		pceomon.stats[EVASION][3]=1
		
	emit_signal("just_attacked", "Alparko", "/weather clear", "", "¡A tomar por culo los bufos!")
