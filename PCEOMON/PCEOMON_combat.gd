extends Skeleton2D
#ARRAYS ENEMIGOS/ALIADOS
var foes = []
var mates = []

var boss : bool = false

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
###


var buffs = []

var stats = {"chemicaldmg" : [5, 1, 0], "physicaldmg" : [5, 1, 0], 
"psychologycaldmg" : [5, 1, 0], "chemicaldfc" : [5, 1, 0],
"physicaldfc" : [5, 1, 0], "speed" : [5, 1, 0]}

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
const poison_damage : int = 1
var stun_counter : int = 0


export(String) var avatar_path

var delta_acum: float = 0


signal just_died
#############################
###########PRUEBAS###########
func _ready():
	actual_stamina = 0
	max_hp = 100
	actual_hp = max_hp

# HACER UN CASE CON EL SIGUIENTE ATAQUE
func attack():
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
	$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
	next_attack = 1
	metadata.time_exists.erase(self)
func next2():
	actual_stamina = 1
# warning-ignore:integer_division
	$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
	next_attack = 2
	metadata.time_exists.erase(self)
func next3():
	actual_stamina = 1
# warning-ignore:integer_division
	$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
	next_attack = 3
	metadata.time_exists.erase(self)
func next4():
	actual_stamina = 1
# warning-ignore:integer_division
	$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
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
	elif (metadata.time_exists.size() == 0):
		delta_acum+=delta
		if (delta_acum>0.01):
			print(attack1 + " progresa")
			delta_acum-=0.01
			actual_stamina = actual_stamina + getstat("speed")
# warning-ignore:integer_division
			$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
			
			if poison_counter > 0 and actual_hp > poison_damage:
				poison_counter -= poison_damage
				self.damage(poison_damage)


func heal(var hp: int):
# warning-ignore:narrowing_conversion
	hp = min(actual_hp+hp,max_hp)
	actual_hp += hp
# warning-ignore:integer_division
	$"StatsSummary/HP".value = actual_hp*100/max_hp


func damage(var damage : int):
	actual_hp = actual_hp - damage
# warning-ignore:integer_division
	$"StatsSummary/HP".value = actual_hp*100/max_hp
	if(actual_hp <= 0):
		self.visible = false
		emit_signal("just_died")

