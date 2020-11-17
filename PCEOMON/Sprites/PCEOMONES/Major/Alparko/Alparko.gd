extends "res://PCEOMONES_classes/R4.gd"


var peaceful : bool = false


func _ready():
	arrow = $Arrow
	name = "Alparko"
	ability = "Peaceful mode"
	attack1 = "/tp"
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
	next_attack_required_stamina = 200
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN al que quieres hacer tp")
	selected_mate = yield(select(true), "completed")
	.next1()

func next2():
	next_attack_required_stamina = 200
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN [tornado]ÍGNEO.[/tornado]")
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
	selected_mate.buff("evasion", 5000, 0.5, 0)
	emit_signal("just_attacked", "Alparko", "/tp", "", "¡Cómo se mueve el hijo de puta de [shake level=10]" + selected_mate.name + "![/shake]")
	emit_signal("buffed", self, [selected_mate], EVASION)
	
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
		pceomon.stats["chemicaldmg"][2]=0
		pceomon.stats["chemicaldmg"][3]=1
		pceomon.stats["physicaldmg"][2]=0
		pceomon.stats["physicaldmg"][3]=1
		pceomon.stats["psychologycaldmg"][2]=0
		pceomon.stats["psychologycaldmg"][3]=1
		pceomon.stats["chemicaldfc"][2]=0
		pceomon.stats["chemicaldfc"][3]=1
		pceomon.stats["physicaldfc"][2]=0
		pceomon.stats["physicaldfc"][3]=1
		pceomon.stats["psychologycaldfc"][2]=0
		pceomon.stats["psychologycaldfc"][3]=1
		pceomon.stats["speed"][2]=0
		pceomon.stats["speed"][3]=1
		pceomon.stats["evasion"][2]=0
		pceomon.stats["evasion"][3]=1
	for pceomon in foes:
		for buff in pceomon.buffs:
			buff[0] = 0
		pceomon.stats["chemicaldmg"][2]=0
		pceomon.stats["chemicaldmg"][3]=1
		pceomon.stats["physicaldmg"][2]=0
		pceomon.stats["physicaldmg"][3]=1
		pceomon.stats["psychologycaldmg"][2]=0
		pceomon.stats["psychologycaldmg"][3]=1
		pceomon.stats["chemicaldfc"][2]=0
		pceomon.stats["chemicaldfc"][3]=1
		pceomon.stats["physicaldfc"][2]=0
		pceomon.stats["physicaldfc"][3]=1
		pceomon.stats["psychologycaldfc"][2]=0
		pceomon.stats["psychologycaldfc"][3]=1
		pceomon.stats["speed"][2]=0
		pceomon.stats["speed"][3]=1
		pceomon.stats["evasion"][2]=0
		pceomon.stats["evasion"][3]=1
		
	emit_signal("just_attacked", "Alparko", "/weather clear", "", "¡A tomar por culo los bufos!")
