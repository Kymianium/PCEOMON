extends Node2D
#ARRAYS ENEMIGOS/ALIADOS
var foes = []
var mates = []

var target = 0
var selecting : bool = false
var selecting_allied: bool = false
var selected_mate = null
var selected_foe = null


const CHEMICAL_DMG = 0
const PHYSICAL_DMG = 1
const PSYCHOLOGYCAL_DMG = 2
const TRUE_DMG = 3
const CHEMICAL_DFC = 4
const PHYSICAL_DFC = 5
const PSYCHOLOGYCAL_DFC = 6
const SPEED = 7
const EVASION = 8
const STUN = 9
const POISON = 10



var boss : bool = false

var manager

var rng = RandomNumberGenerator.new()

signal just_attacked(user, attack, objective, string)
# warning-ignore:unused_signal						
signal attacked(user, target, damage, damage_type)
signal status(user, target, status)
####
# DAMAGE TYPE
####
# warning-ignore:unused_signal
signal buffed(user, target, stat)
# warning-ignore:unused_signal
signal shielded(user, target, amount)
# warning-ignore:unused_signal
signal healed(user, target, amount)
# warning-ignore:unused_signal
signal died(pceomon)
signal announcement(announce)
# warning-ignore:unused_signal
signal permanent_announcement(announce)
signal target_selected
signal sprite_pressed(name,boss)
# warning-ignore:unused_signal
signal particle(path, posx, posy)
signal revive(pceomon)
#STATS

###
#	Los stats son un poco confusos, así que voy a explicarlos por aqui:
# cuando quieres obtener un stat, hay una función (getstat) que te obtiene
# el valor del stat. En el array, hay tres valores. El valor que devuelve
# getstat es (valor1)*valor2+valor3. Esto es:
#
#		El valor 1 es el valor "base"
#
#		El valor 2 es el valor "multiplicador", proveniente de bufos, etc.
#
#		El valor 3 es el valor "sumador", del mismo origen que el multiplicador.
#
#	El array de bufos guarda, de manera ordenada, cada uno de los bufos y su
# duración restante. Este debe disminuir en función del tiempo.
#
#	La evasión siempre decrece cuando mejora, es decir su multiplicador tendrá que ser 0 < x < 1
#	y nunca será un bufo de suma. Además cuanto mayor sea el multiplicador, menor será el bufo.
###


var buffs = []

var max_permanent_buff = 4

var stats = {CHEMICAL_DMG : [5, 1, 0, 1], PHYSICAL_DMG : [5, 1, 0, 1], 
PSYCHOLOGYCAL_DMG : [5, 1, 0, 1], CHEMICAL_DFC : [5, 1, 0, 1],
PHYSICAL_DFC : [5, 1, 0, 1], PSYCHOLOGYCAL_DFC :  [5, 1, 0, 1], 
SPEED : [5, 1, 0, 1], EVASION : [1, 1, 0, 1]}

func buff(stat : int, duration : int, product : float, sum : int):
	var buff = [duration, stat, product, sum]
	buffs.append(buff)
	stats[stat][1]*=product
	stats[stat][2]+=sum
	
func permanent_buff(stat : int, product : float, sum : int):
	stats[stat][0]+=sum
	stats[stat][3]*=product
	if stats[stat][3]>max_permanent_buff:
		stats[stat][3]=max_permanent_buff
	
func getstat(stat : int):
	var rawstat = stats[stat]
	return (rawstat[0]*rawstat[1]*rawstat[3]+rawstat[2])

func update_buffs():
	var toremove = []
	var removed = 0
	for i in range(buffs.size()):
		buffs[i][0]-=1
		if (buffs[i][0] == 0):
			stats[buffs[i][1]][1]/=buffs[i][2]
			stats[buffs[i][1]][2]-=buffs[i][3]
			toremove.append(i)
	for i in toremove:
		buffs.remove(i-removed)
		
	

# VIDA Y ESTAMINA
var actual_hp : int
var max_hp : int
var actual_stamina : int
var next_attack_required_stamina : int = 10
var next_attack : int = 0

#ATAQUES, HABILIDAD Y TIPO
var type : String
var attack1 : String
var attack2 : String
var attack3 : String
var attack4 : String
var ability : String

#CAMBIOS DE ESTADO
var poison_counter: int = 0
const poison_damage : int = 50
var stun_counter : int = 0
var dimension = [null]


export(String) var avatar_path

var delta_acum: float = 0

##################SEÑALES MISCELÁNEAS
#	Sirven para cosas turbias. Cada una debe de ir acompañada de su correspondiente
# comentario.
# Paco hijo de puta.

var arrow #Esta es la flecha que apunta al PCEOMÓN


#############################
###########PRUEBAS###########
func _ready():
	actual_stamina = 0
	max_hp = 100
	actual_hp = max_hp
	arrow = $Arrow
	$HBoxContainer/StatsSummary/Shield.value = 0

func _input(event):
	
	if(selecting):
		if event is InputEventKey:
			if event.scancode == KEY_ENTER:		#El event.pressed es para
			# que solo se ejecute al pulsarlo
				emit_signal("target_selected")
			if event.scancode == KEY_LEFT and event.pressed:
				change_selected(false)
			if event.scancode == KEY_RIGHT and event.pressed:
				change_selected(true)


# warning-ignore:shadowed_variable
func target_selected(pceomon,boss):
	if (selecting and (not boss) == selecting_allied):
		if (selecting_allied and mates.has(pceomon)):
			for mate in range(mates.size()):
				mates[mate].arrow.visible = false
				if (mates[mate] == pceomon):
					target = mate
					emit_signal("target_selected")					
		elif (not selecting_allied and foes.has(pceomon)):
			for enemy in range(foes.size()):
				foes[target].arrow.visible = false
				if (foes[enemy] == pceomon):
					target = enemy
					emit_signal("target_selected")
					return





# HACER UN CASE CON EL SIGUIENTE ATAQUE
func attack():
	$"HBoxContainer/StatsSummary/Stamina".value = 0
	if(next_attack == 1):
		atk1()
	elif(next_attack == 2):
		atk2()
	elif(next_attack == 3):
		atk3()
	else:
		atk4()
#############################
func atk1():
	pass
func atk2():
	pass
func atk3():
	pass
func atk4():
	pass

func next1():
	actual_stamina = 1
# warning-ignore:integer_division
	$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
	next_attack = 1
	metadata.time_exists.erase(self)
func next2():
	actual_stamina = 1
# warning-ignore:integer_division
	$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
	next_attack = 2
	metadata.time_exists.erase(self)
func next3():
	actual_stamina = 1
# warning-ignore:integer_division
	$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
	next_attack = 3
	metadata.time_exists.erase(self)
func next4():
	actual_stamina = 1
# warning-ignore:integer_division
	$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
	next_attack = 4
	metadata.time_exists.erase(self)


func _process(delta):
	if (actual_hp <= 0):
		return
	elif(actual_stamina==0 and not boss):
		if (not metadata.time_exists.has(self)):
			metadata.time_exists.append(self)
	elif(actual_stamina >= next_attack_required_stamina):
		attack()
		actual_stamina = 0
	elif (metadata.time_should_run()):
		delta_acum+=delta
		if (delta_acum>0.1):
			delta_acum-=0.1
			actual_stamina = actual_stamina + getstat(SPEED)
# warning-ignore:integer_division
			$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
			
			if poison_counter > 0 and actual_hp > poison_damage:
				poison_counter -= poison_damage
				if (poison_counter <= 0):
					$"HBoxContainer/Status/Poison".visible = false
					emit_signal("announcement","El envenenamiento de " + self.name + " ha terminado")
				self.damage(poison_damage)

func revive(hp):
	actual_hp = hp
	emit_signal("revive",self)


func heal(var hp: int):
	if (actual_hp == 0):
		revive(hp)
	else:
	# warning-ignore:narrowing_conversion
		actual_hp = min(actual_hp+hp,max_hp)
	# warning-ignore:integer_division
		$"HBoxContainer/StatsSummary/HP".value = actual_hp*100/max_hp


func unicast_damage(var damage_done, var dst : String, var attack : String, var description : String):
	if (damage_done > 0):
		emit_signal("just_attacked",self.name,attack,dst,description)
	elif damage_done == 0:
		emit_signal("just_attacked",self.name,attack,dst,"Pero ha fallado")


func make_damage(attacked,dmg,scalation,dmg_type):
	if (dmg_type == PHYSICAL_DMG):
		return attacked.take_physical_damage(calculate_physical_damage(dmg,scalation))
	if (dmg_type == PSYCHOLOGYCAL_DMG):
		return attacked.take_psychological_damage(calculate_psychological_damage(dmg,scalation))
	if (dmg_type == CHEMICAL_DMG):
		return attacked.take_chemical_damage(calculate_chemical_damage(dmg,scalation))

func calculate_chemical_damage(var attack_damage : int, var scalation : float):
	return attack_damage+(scalation*getstat(CHEMICAL_DMG))

func take_chemical_damage(var damage):
	return damage(damage/(1+getstat(CHEMICAL_DFC)/100))

func calculate_physical_damage(var attack_damage : int, var scalation : float):
	return attack_damage+(scalation*getstat(PHYSICAL_DMG))

func take_physical_damage(var damage):
	return damage(damage/(1+getstat(PHYSICAL_DFC)/100))
	
func calculate_psychological_damage(var attack_damage : int, var scalation : float):
	return attack_damage+(scalation*getstat(PSYCHOLOGYCAL_DMG))

func take_psychological_damage(var damage):
	return damage(damage/(1+getstat(PSYCHOLOGYCAL_DFC)/100))
	

func damage(var damage : int):
	if rng.randf() > getstat(EVASION):
		return 0
	actual_hp = actual_hp - damage
# warning-ignore:integer_division
	$"HBoxContainer/StatsSummary/HP".value = actual_hp*100/max_hp
	if(actual_hp <= 0):
		self.visible = false
		emit_signal("died", self)
		actual_hp = 0
	return damage
	
func poison(var damage : int):
	poison_counter = damage
	$"HBoxContainer/Status/Poison".visible = true
	
	# FUNCIÓN PARA SELECCIONAR UN PCEOMON ALIADO 
func select(var allied : bool):
	target = 0
	selecting = true
	selecting_allied = allied
	if allied:
		mates[target].arrow.visible = true
		yield(self, "target_selected")
		mates[target].arrow.visible = false
		selecting = false
		return mates[target]
	else:
		foes[target].arrow.visible = true
		yield(self, "target_selected")
		foes[target].arrow.visible = false
		selecting = false
		return foes[target]
	
		
func change_selected(var forward : bool):
	if mates[target].arrow.visible:
		mates[target].arrow.visible = false
		if forward:
			target+=1
			target=target%mates.size()
		else:
			target-=1
			if target==-1:
				target=mates.size()-1
		mates[target].arrow.visible = true
	elif foes[target].arrow.visible:
		foes[target].arrow.visible = false
		if forward:
			target+=1
			target=target%foes.size()
		else:
			target-=1
			if target==-1:
				target=foes.size()-1
		foes[target].arrow.visible = true
		

func _on_SpriteContainer_sprite_pressed():
	emit_signal("sprite_pressed",self,boss)
	
func select_combat(var message : String, var ally : bool):
	emit_signal("permanent_announcement", message)
	if ally:
		selected_mate = yield(select(ally), "completed")
	else:
		selected_foe = yield(select(ally), "completed")
