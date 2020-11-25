extends Node2D
#ARRAYS ENEMIGOS/ALIADOS
var foes = []	#Array de los enemigos
var mates = []	#Array de los aliados
var select_candidates = []	#Array de los "candidatos a elección". Esto es útil
#cuando hay que seleccionar o bien aliados, o bien enemigos, o bien ambos.


var target = 0
var selecting : bool = false
var targets = []


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

const ALLY = 30
const ENEMY = 31
const BOTH = 32



var boss : bool = false

var manager	#Esta función contiene al combat manager

var rng = RandomNumberGenerator.new()

signal just_attacked(user, attack, objective, string)
# warning-ignore:unused_signal						
signal attacked(user, target, damage, damage_type)
signal status(user, target, status)
####
# DAMAGE TYPE
####
# warning-ignore:unused_signal
signal buffed(user, target, stat, duration, product, sum)
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

func buff(target, stat : int, duration : int, product : float, sum : int):
	var buff = [duration, stat, product, sum]
	for tar in target:
		tar.buffs.append(buff)
		tar.stats[stat][1]*=product
		tar.stats[stat][2]+=sum
	emit_signal("buffed", self, target, stat, duration, product, sum)
	
func permanent_buff(target, buffstat, product : float, sum : int):
	print(target)
	for tar in target:
		for stat in buffstat:
			tar.stats[stat][0]+=sum
			tar.stats[stat][3]*=product
			if tar.stats[stat][3]>max_permanent_buff:
				tar.stats[stat][3]=max_permanent_buff
	emit_signal("buffed", self, target, buffstat, 0, product, sum)
	
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
	var chosen
	for candidate in select_candidates.size():
		select_candidates[candidate].arrow.visible = false
		if (select_candidates[candidate] == pceomon):
			chosen = candidate
	target = chosen
	emit_signal("target_selected")
#	if (selecting and (not boss) == selecting_allied):
#		if (selecting_allied and mates.has(pceomon)):
#			for mate in range(mates.size()):
#				mates[mate].arrow.visible = false
#				if (mates[mate] == pceomon):
#					target = mate
#					emit_signal("target_selected")
#		elif (not selecting_allied and foes.has(pceomon)):
#			for enemy in range(foes.size()):
#				foes[target].arrow.visible = false
#				if (foes[enemy] == pceomon):
#					target = enemy
#					emit_signal("target_selected")
#					return





# HACER UN CASE CON EL SIGUIENTE ATAQUE
func attack():
	actual_stamina = 0
	$"HBoxContainer/StatsSummary/Stamina".value = 0
	if(next_attack == 1):
		atk1()
	elif(next_attack == 2):
		atk2()
	elif(next_attack == 3):
		atk3()
	else:
		atk4()
	targets = []
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

func heal_custom(healed, hp):
	var i = 0
	for hd in healed:
		if (hd.actual_hp == 0):
			hd.revive(hp)
		else:
			hd.actual_hp = min(hd.actual_hp+hp[i],hd.max_hp)
		# warning-ignore:integer_division
			hd.recalculate_hp()
		i+=1
	emit_signal("healed", self, healed, hp)

func heal(healed, hp):
	for hd in healed:
		if (hd.actual_hp == 0):
			hd.revive(hp)
		else:
		# warning-ignore:narrowing_conversion
			hd.actual_hp = min(hd.actual_hp+hp,hd.max_hp)
		# warning-ignore:integer_division
			hd.recalculate_hp()
	emit_signal("healed", self, healed, hp)

func recalculate_hp():
	$"HBoxContainer/StatsSummary/HP".value = actual_hp*100/max_hp

func unicast_damage(var damage_amount, var scalation, var damage_type, var dst, var attack : String, var description : String):
	var failed : bool = true
	var damages = []
	var last_damage
	print(targets)
	for tar in dst:
		if tar!=null:	#arreglar
			last_damage = make_damage(tar, damage_amount, scalation, damage_type)
			damages.append(last_damage)
			if last_damage!=0:
				failed = false
	if (not failed):
		for ind in range(dst.size()):
			emit_signal("just_attacked",self.name,attack,dst[ind].name,description)
		emit_signal("attacked",self,dst,damages,damage_type)
	else:
		for ind in range(dst.size()):
			emit_signal("just_attacked",self.name,attack,dst[ind].name,"Pero ha fallado")
		emit_signal("attacked",self,dst,damages,damage_type)

func new_foe(foe):
	foes.append(foe)

func new_mate(mate):
	mates.append(mate)

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
	
func poison(target, damage : int):
	for tar in target:
		tar.poison_counter = damage
		tar.make_poison_visible()
	emit_signal("status", self, target, POISON)

func make_poison_visible():
	$"HBoxContainer/Status/Poison".visible = true
	# FUNCIÓN PARA SELECCIONAR UN PCEOMON ALIADO 
	
func select(var identity):
	target = 0
	selecting = true
	select_candidates = []
	if identity == ALLY:
		select_candidates += mates #SI HACES ESTO, GODOT LE AÑADE AL PRIMER ARRAY
		#LOS ELEMENTOS DEL SEGUNDO, RE LOCO MI REY
		select_candidates[target].arrow.visible = true
		print("Seleccionando aliado")
		yield(self, "target_selected")
		select_candidates[target].arrow.visible = false
		selecting = false
		return select_candidates[target]
	elif identity == ENEMY:
		print("Seleccionando enemigo")
		select_candidates += foes
		select_candidates[target].arrow.visible = true
		yield(self, "target_selected")
		select_candidates[target].arrow.visible = false
		selecting = false
		return select_candidates[target]
	else:
		print("Seleccionando lo que me salga de los cojones")
		select_candidates += mates
		select_candidates += foes
		select_candidates[target].arrow.visible = true
		yield(self, "target_selected")
		select_candidates[target].arrow.visible = false
		selecting = false
		return select_candidates[target]
		
func change_selected(var forward : bool):
	select_candidates[target].arrow.visible = false
	if forward:
		target+=1
		target=target%select_candidates.size()
	else:
		target-=1
		if target==-1:
			target=select_candidates.size()-1
	select_candidates[target].arrow.visible = true

func _on_SpriteContainer_sprite_pressed():
	emit_signal("sprite_pressed",self,boss)
	
func select_combat(var message : String, var target):
	if target == ALLY:
		if mates != []:
			emit_signal("permanent_announcement", message)
			targets.append(yield(select(ALLY), "completed"))
		else:
			emit_signal("announcement", "No hay aliados para seleccionar")
			next_attack_required_stamina = 1
	elif target == ENEMY:
		if foes != []:
			emit_signal("permanent_announcement", message)
			targets.append(yield(select(ENEMY), "completed"))
		else:
			emit_signal("announcement", "No hay enemigos para seleccionar")
			next_attack_required_stamina = 1
	elif target == BOTH:
		if foes != [] or mates != []:
			emit_signal("permanent_announcement", message)
			targets.append(yield(select(BOTH), "completed"))
		else:
			emit_signal("announcement", "No hay aliados ni enemigos para seleccionar")
	
