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
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN al que quieres hacer /kill")
	selected_foe = yield(select(ENEMY), "completed")
	.next1()

func next2():
	next_attack_required_stamina = 200
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN [tornado]ÍGNEO.[/tornado]")
	selected_mate = yield(select(ALLY), "completed")
	.next2()

func next3():
	next_attack_required_stamina = 300
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN al que quieres proteger")
	selected_mate = yield(select(ALLY), "completed")
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
	var chance = rng.randi() % 10000
	var damage_done
	if (chance==69):
		damage_done = selected_foe.damage(selected_foe.max_hp)
		emit_signal("just_attacked", "Alparko", "/kill", selected_foe.name, "\n\t [shake level=50 rate=1] EL TOQUE DE LA MUERTE [/shake]\n [fade start=4 length=28] Señor Stark, no me encuentro muy bien...[/fade]")
		emit_signal("attacked", self, [selected_foe],[selected_foe.max_hp], TRUE_DMG)
		return
	damage_done = make_damage(selected_foe, 300, 0.3, PSYCHOLOGYCAL_DMG)
	unicast_damage(damage_done,selected_foe.name,"/kill","¡OOF, ESO ESTUVO CERCA!")
	emit_signal("attacked", self, [selected_foe],[damage_done], PSYCHOLOGYCAL_DMG)
	
func atk2():
	selected_mate.permanent_buff(PHYSICAL_DMG, 1.2, 0)
	emit_signal("just_attacked", "Alparko", "Aspecto Ígneo", "", "Ahora " + selected_mate.name + " es  [tornado]ÍGNEO.[/tornado]")
	emit_signal("buffed", self, [selected_mate], PHYSICAL_DMG)

func atk3():
	selected_mate.permanent_buff(PHYSICAL_DFC, 1.1, 0)
	selected_mate.permanent_buff(CHEMICAL_DFC, 1.1, 0)
	selected_mate.permanent_buff(PSYCHOLOGYCAL_DFC, 1.1, 0)
	emit_signal("just_attacked", "Alparko", "Protección", "", "¡" + selected_mate.name + " tiene una piel de hierro!")
	emit_signal("buffed", self, [selected_mate], PHYSICAL_DFC)
	emit_signal("buffed", self, [selected_mate], CHEMICAL_DFC)
	emit_signal("buffed", self, [selected_mate], PSYCHOLOGYCAL_DFC)
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
