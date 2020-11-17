extends "res://PCEOMON_combat.gd"

var CoffeeParticle = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CoffeeParticle.tscn"
var ChocolateParticle = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ChocolateHeal.tscn"
var CommunismDeb = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ComunismDebuff.tscn"
var CommunismBuf = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ComunismHeal.tscn"


func _ready():
	name = "Cafetera Comunista"
	ability = ""
	attack1 = "Café de avellana"
	attack2 = "Lucha de clases"
	attack3 = "Reunión de algebristas"
	attack4 = "Chocolate caliente"
	type = "Menor"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CafeteraComunista_avatar.png"
	next_attack_required_stamina = 1300
	

func next1():
	next_attack_required_stamina = 500
	emit_signal("permanent_announcement", "Selecciona al PCEOMÓN falto de [shake level=20] cafeína [/shake]")
	selected_mate = yield(select(true), "completed")
	.next1()
func next2():
	next_attack_required_stamina = 300
	.next2()

func next3():
	next_attack_required_stamina = 200
	.next3()

func next4():
	next_attack_required_stamina = 200
	.next4()


func atk1():
	#Café de avellanas, aumenta la velocidad con la que se restaura la stamina
	selected_mate.buff(SPEED, 1000, 1.5, 0)
	emit_signal("particle", CoffeeParticle, selected_mate.position.x+25, selected_mate.position.y+100)
	emit_signal("just_attacked", "La cafetera comunista", "Café de avellana", "", "Con este manjar, " + selected_mate.name + " ahora va más [tornado freq=5]rápido[/tornado]")
	emit_signal("buffed", self, [selected_mate], SPEED)
	
func atk2():
	#Roba un poco de vida al enemigo con mas porcentaje de vida y le da una parte al aliado con menor porcentaje de vida

	var more_healed = null
	var less_healed = null
	var damage_done : int = 0
	for enemy in foes:
		if (more_healed == null || enemy.actual_hp/enemy.max_hp > more_healed.actual_hp/more_healed.max_hp):
			more_healed = enemy
	damage_done = more_healed.take_psychologycal_damage(calculate_phychological_damage(50,0.5))
	if (damage_done != 0):
		for ally in mates:
			if (less_healed == null || less_healed.actual_hp/less_healed.max_hp > ally.actual_hp/ally.max_hp):
				less_healed = ally
		less_healed.heal(calculate_phychological_damage(50,0.5)/2)
		emit_signal("particle", CommunismBuf, less_healed.position.x+25, less_healed.position.y+100)
		emit_signal("particle", CommunismDeb, more_healed.position.x+25, more_healed.position.y+100)		
		emit_signal("just_attacked","La cafetera comunista", "Lucha de clases", more_healed.name,"¡El poder de Lenin ha sanado a " + less_healed.name + "!")
		emit_signal("attacked", self, [more_healed], calculate_phychological_damage(50,0.5), PSYCHOLOGYCAL_DMG)
		emit_signal("healed", self, [less_healed], calculate_phychological_damage(50,0.5)/2)
	else:
		print("No ha hecho daño")
func atk3():
	self.buff(EVASION, 1000, 0.8, 0)
	emit_signal("just_attacked","La cafetera comunista", "Reunión de algebristas","","La cafetera se esconde entre profesores. ¡Aumenta su evasión!")
	emit_signal("buffed", self, self, EVASION)
func atk4():
	#Sana al aliado más herido (por porcentajes)
	var less_healed = null
	for ally in mates:
		if (less_healed == null || less_healed.actual_hp/less_healed.max_hp > ally.actual_hp/ally.max_hp):
			less_healed = ally
	less_healed.heal(calculate_chemical_damage(30,0.3))
	emit_signal("particle", ChocolateParticle, less_healed.position.x+25, less_healed.position.y+100)
	emit_signal("just_attacked","La cafetera comunista","Chocolate caliente","","El chocolate caliente revitaliza a " + less_healed.name)
	emit_signal("healed", self, [less_healed], calculate_chemical_damage(30,0.3))
