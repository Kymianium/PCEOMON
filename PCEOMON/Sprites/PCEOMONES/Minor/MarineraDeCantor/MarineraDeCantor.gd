extends "res://PCEOMON_combat.gd"

var CoffeeParticle = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CoffeeParticle.tscn"
var ChocolateParticle = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ChocolateHeal.tscn"
var CommunismDeb = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ComunismDebuff.tscn"
var CommunismBuf = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/ComunismHeal.tscn"


func _ready():
	name = "Marinera de Cantor"
	ability = "No numerable"
	attack1 = "Ensaladillado"
	attack2 = "Medida nula"
	attack3 = "Rosquillazo"
	attack4 = "Aperitivo"
	type = "Menor"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/CafeteraComunista/CafeteraComunista_avatar.png"
	next_attack_required_stamina = 1300
	

func next1():
	next_attack_required_stamina = 500
	emit_signal("permanent_announcement", "¡Selecciona a quién hay que ensaladillar!")
	selected_foe= yield(select(false), "completed")
	.next1()
func next2():
	next_attack_required_stamina = 300
	emit_signal("permanent_announcement", "¡Selecciona quién tiene medida nula!")
	selected_mate = yield(select(true), "completed")
	.next2()

func next3():
	next_attack_required_stamina = 400
	emit_signal("permanent_announcement", "Alguien se va a llevar un rosquillazo...")
	selected_foe = yield(select(false), "completed")
	.next3()

func next4():
	next_attack_required_stamina = 2000
	emit_signal("permanent_announcement", "Moriré... Por ti...")
	selected_mate = yield(select(true), "completed")
	.next4()


func atk1():
	var damage_done = make_damage(selected_foe, 100, 0.3, CHEMICAL_DMG)
	unicast_damage(damage_done,selected_foe.name,"Ensaladillado","¡Mayonesa, huevo, zanahora, yo qué coño sé! ¡Sufre mamón!")
	selected_foe.buff(SPEED, 10000, 0.6, 0)
	emit_signal("buffed", self, [selected_foe], SPEED)
	emit_signal("attacked", self, [selected_foe],[damage_done], PSYCHOLOGYCAL_DMG)
	
func atk2():
	selected_mate.buff(EVASION, 3000, 0.5, 0)
	emit_signal("just_attacked", self.name, "Medida nula", "", "¿¡Dónde se ha metido " + selected_mate.name + "!?")
	emit_signal("buffed", self, [selected_mate], EVASION)
func atk3():
	var damage_done = make_damage(selected_foe, 100, 0.2, PHYSICAL_DMG)
	unicast_damage(damage_done,selected_foe.name,"Rosquillazo","... Em... Sí, bueno... Le dió un rosquillazo. Don't mess with Cantor, I guess.")
	emit_signal("attacked", self, [selected_foe], [damage_done],PHYSICAL_DMG)
func atk4():
	selected_mate.permanent_buff(CHEMICAL_DMG, 1.5, 50)
	selected_mate.permanent_buff(PHYSICAL_DMG, 1.5, 50)
	selected_mate.permanent_buff(PSYCHOLOGYCAL_DMG, 1.5, 50)
	selected_mate.permanent_buff(CHEMICAL_DFC, 1.5, 50)
	selected_mate.permanent_buff(PHYSICAL_DFC, 1.5, 50)
	selected_mate.permanent_buff(PSYCHOLOGYCAL_DFC, 1.5, 50)
	selected_mate.permanent_buff(SPEED, 1.5, 0)
	damage(max_hp)
	emit_signal("just_attacked",self.name,"Aperitivo","","D.E.P., Marinera de Cantor. Siempre guardaremos un huequito de medida nula para ti en nuestro corazón <3")
	emit_signal("buffed", self, selected_mate, [CHEMICAL_DFC, CHEMICAL_DMG, PHYSICAL_DFC, PHYSICAL_DMG, PSYCHOLOGYCAL_DFC, PSYCHOLOGYCAL_DMG, SPEED])
