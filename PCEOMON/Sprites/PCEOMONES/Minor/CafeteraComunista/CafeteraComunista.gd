extends "res://PCEOMONES_classes/MINOR.gd"

var CoffeeParticle = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CoffeeParticle.tscn"
var ChocolateParticle = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ChocolateHeal.tscn"
var CommunismDeb = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ComunismDebuff.tscn"
var CommunismBuf = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ComunismHeal.tscn"
var refill = 5

func _ready():
	name = "Cafetera Comunista"
	ability = "Reponer"
	attack1 = "Café de avellana"
	attack2 = "Lucha de clases"
	attack3 = "Reunión de algebristas"
	attack4 = "Chocolate caliente"
	type = "Menor"
	avatar_path = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CafeteraComunista_avatar.png"
	next_attack_required_stamina = 1300
	._ready()
	att3name = "Reunión"

func next1():
	next_attack_required_stamina = 500
	select_combat("Selecciona al PCEOMÓN falto de [shake level=20] cafeína [/shake]",ALLY)
	.next1()
func next2():
	if foes.empty():
		emit_signal("announcement", "¡No hay enemigos a quien atacar!")
		next_attack_required_stamina=1
		return
	if mates.empty():
		emit_signal("announcement", "¡No hay aliados a los que sanar!")
		next_attack_required_stamina=1
		return
	next_attack_required_stamina = 300
	.next2()

func next3():
	next_attack_required_stamina = 200
	.next3()

func next4():
	if mates.empty():
		emit_signal("announcement", "¡No hay aliados a los que sanar!")
		next_attack_required_stamina=1
		return
	next_attack_required_stamina = 200
	.next4()


func atk1():
	#Café de avellanas, aumenta la velocidad con la que se restaura la stamina
	targets[0].buff(targets, SPEED, 1000, 1.5, 0)
	emit_signal("particle", CoffeeParticle, targets[0].position.x+25, targets[0].position.y+100)
	emit_signal("just_attacked", "La cafetera comunista", "Café de avellana", "", "Con este manjar, " + targets[0].name + " ahora va más [tornado freq=5]rápido[/tornado]")
	emit_signal("buffed", self, targets, SPEED)
	emit_signal("camera_zoom",targets[0])
	.atk1()
	
func atk2():
	#Roba un poco de vida al enemigo con mas porcentaje de vida y le da una parte al aliado con menor porcentaje de vida
	var more_healed = null
	var less_healed = []
	var damage_done : int = 0
	for enemy in foes:
		if (more_healed == null || enemy.actual_hp/enemy.max_hp > more_healed.actual_hp/more_healed.max_hp):
			more_healed = enemy
	if more_healed != null:
		damage_done = make_damage(more_healed,100,0.5,PSYCHOLOGYCAL_DMG)
	if (damage_done != 0):
		for ally in mates:
			if (less_healed == [] || less_healed[0].actual_hp/less_healed[0].max_hp > ally.actual_hp/ally.max_hp):
				less_healed = [ally]
		heal(less_healed, damage_done/2)
		emit_signal("particle", CommunismBuf, less_healed[0].position.x+25, less_healed[0].position.y+100)
		emit_signal("particle", CommunismDeb, more_healed.position.x+25, more_healed.position.y+100)
		emit_signal("just_attacked","La cafetera comunista", "Lucha de clases", more_healed.name,"¡El poder de Lenin ha sanado a " + less_healed[0].name + "!")
		emit_signal("attacked", self, [more_healed], [damage_done], PSYCHOLOGYCAL_DMG)
		emit_signal("camera_zoom",less_healed[0])
	else:
		emit_signal("just_attacked",self.name,"Lucha de clases", more_healed.name,"Pero ha fallado, el comunismo no funciona")
	.atk2()
func atk3():
	buff([self], EVASION, 1000, 0.8, 0)
	emit_signal("just_attacked","La cafetera comunista", "Reunión de algebristas","","La cafetera se esconde entre profesores. ¡Aumenta su evasión!")
	emit_signal("camera_zoom",self)
	$SpriteContainer/AnimatedSprite.animation = "reunion"
	.atk3()
func atk4():
	#Sana al aliado más herido (por porcentajes)
	var less_healed = []
	for ally in mates:
		if (less_healed == [] || less_healed[0].actual_hp/less_healed[0].max_hp > ally.actual_hp/ally.max_hp):
			less_healed = [ally]
	heal(less_healed, calculate_chemical_damage(30,0.3))
	emit_signal("particle", ChocolateParticle, less_healed[0].position.x+25, less_healed[0].position.y+100)
	emit_signal("just_attacked","La cafetera comunista","Chocolate caliente","","El chocolate caliente revitaliza a " + less_healed[0].name)
	emit_signal("camera_zoom",less_healed[0])
	.atk4()

#Redefino esto para poder meter la pasiva
func _process(delta):
	if (actual_hp <= 0):
		return
	elif(actual_stamina==0):
		if (not metadata.time_exists.has(self) and not boss):
			metadata.time_exists.append(self)
		else:
			boss_next_attack()
	elif(actual_stamina >= next_attack_required_stamina):
		attack()
	elif(stun_counter > 0):
		delta_acum+=delta
		if (delta_acum > 0.1):
			delta_acum-=0.1
			stun_counter-=1
			if (stun_counter<=0):
				$HBoxContainer/Status/Confusion.visible = false
				$HBoxContainer/Status/Sleep.visible = false
	elif (metadata.time_should_run()):
		delta_acum+=delta
		if (delta_acum>0.1):
			delta_acum-=0.1
			update_buffs()
			actual_stamina = actual_stamina + getstat(SPEED)
			refill -= 1
			if (refill <= 0):
				emit_signal("announcement","¿Qué hora es?¡Es hora de reponer [shake level=20] cafeína [/shake]!")
				buff([self], SPEED, 8, 1, 15)
				refill = 50
# warning-ignore:integer_division
			$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
			if poison_counter > 0 and actual_hp > poison_damage:
				poison_counter -= poison_damage
				if (poison_counter <= 0):
					$"HBoxContainer/Status/Poison".visible = false
					emit_signal("announcement","El envenenamiento de " + self.name + " ha terminado")
					return
				self.damage(poison_damage)

