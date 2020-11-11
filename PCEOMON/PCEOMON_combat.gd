extends Skeleton2D
#ARRAYS ENEMIGOS/ALIADOS
var foes = []
var mates = []

var target = 0
var selecting : bool = false
var selecting_allied: bool = false

var boss : bool = false

var manager

var rng = RandomNumberGenerator.new()

signal just_attacked(user, attack, objective, string)
signal announcement(announce)
signal permanent_announcement(announce)
signal target_selected
signal target_selected_by_key
signal sprite_pressed(name,boss)
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

var stats = {"chemicaldmg" : [5, 1, 0], "physicaldmg" : [5, 1, 0], 
"psychologycaldmg" : [5, 1, 0], "chemicaldfc" : [5, 1, 0],
"physicaldfc" : [5, 1, 0], "speed" : [5, 1, 0], "evasion" : [1,1,0]}

func buff(stat : String, duration : int, product : int, sum : int):
	var buff = [duration, stat, product, sum]
	buffs.append(buff)
	stats[stat][1]*=product
	stats[stat][2]+=sum
	
func getstat(stat : String):
	var rawstat = stats[stat]
	return (rawstat[0]*rawstat[1]+rawstat[2])

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

#ATAQUES Y HABILIDAD
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



signal just_died(pceomon)
#############################
###########PRUEBAS###########
func _ready():
	actual_stamina = 0
	max_hp = 100
	actual_hp = max_hp

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


func target_selected(pceomon,boss):
	if (selecting and (not boss) == selecting_allied):
		if (selecting_allied):
			for mate in range(mates.size()):
				if (mates[mate] == pceomon):
					target = mate
					emit_signal("target_selected")
					return
		else:
			for enemy in range(foes.size()):
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
		if (delta_acum>0.01):
			delta_acum-=0.01
			actual_stamina = actual_stamina + getstat("speed")
# warning-ignore:integer_division
			$"HBoxContainer/StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
			
			if poison_counter > 0 and actual_hp > poison_damage:
				poison_counter -= poison_damage
				if (poison_counter <= 0):
					$"HBoxContainer/VBoxContainer/Poison".visible = false
					emit_signal("announcement","El envenenamiento de " + self.name + " ha terminado")
				self.damage(poison_damage)


func heal(var hp: int):
# warning-ignore:narrowing_conversion
	hp = min(actual_hp+hp,max_hp)
	actual_hp += hp
# warning-ignore:integer_division
	$"HBoxContainer/StatsSummary/HP".value = actual_hp*100/max_hp



func damage(var damage : int):
	
	if rng.randf() > getstat("evasion"):
		emit_signal("announcement","El ataque falló")
		return 0
	actual_hp = actual_hp - damage
# warning-ignore:integer_division
	$"HBoxContainer/StatsSummary/HP".value = actual_hp*100/max_hp
	if(actual_hp <= 0):
		self.visible = false
		emit_signal("just_died", self)
		return 2
	return 1
	
func poison(var damage : int):
	poison_counter = damage
	$"HBoxContainer/VBoxContainer/Poison".visible = true
	
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
		foes[target].arrow.visible = false
		yield(self, "target_selected")
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
	print("eo")
	emit_signal("sprite_pressed",self,boss)
