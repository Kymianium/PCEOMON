extends Skeleton2D
#ARRAYS ENEMIGOS/ALIADOS
var foes = []
var mates = []

#BUFOS
var buffs = {"chemicaldmg" : [3,1.4]}

#STATS
var chemicaldmg : int = 1
var physicaldmg : int = 1
var psychologycaldmg : int = 1
var chemicaldfc : int
var physicaldfc : int
var psychologycaldfc : int
var speed : int = 2
var actual_hp : int
var max_hp : int
var actual_stamina : int
var next_attack_required_stamina : int

#ATAQUES Y HABILIDAD
var attack1 : String
var attack2 : String
var attack3 : String
var attack4 : String
var ability : String

#CAMBIOS DE ESTADO
var poison_counter: int = 0
const poison_damage : int = 1


export(String) var avatar_path

var delta_acum: float = 0


signal just_died
signal my_turn

#############################
###########PRUEBAS###########
func _ready():
	actual_stamina = 0
	next_attack_required_stamina = 10000
	max_hp = 100
	actual_hp = max_hp

func attack():
	emit_signal("my_turn")
	metadata.time_exists.append(self)
	print(metadata.time_exists)
#############################
func atk1():
	pass
func atk2():
	pass
func atk3():
	pass
func atk4():
	pass
func ability():
	pass

func end_attack():
	metadata.time_exists.erase(self)
	$"StatsSummary/Stamina".value = 0

func _process(delta):
	if (actual_hp <= 0):
		return

	elif(actual_stamina >= next_attack_required_stamina):
		attack()
		actual_stamina = 0
	elif (metadata.time_exists.size() == 0):
		delta_acum+=delta
		if (delta_acum>0.01):
			delta_acum-=0.01
			actual_stamina = actual_stamina + speed
			$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina
			
			if poison_counter > 0 and actual_hp > poison_damage:
				poison_counter -= poison_damage
				self.damage(poison_damage)


func heal(var hp: int):
	hp = min(actual_hp+hp,max_hp)
	actual_hp += hp
	$"StatsSummary/HP".value = actual_hp*100/max_hp


func damage(var damage : int):
	actual_hp = actual_hp - damage
	$"StatsSummary/HP".value = actual_hp*100/max_hp
	if(actual_hp <= 0):
		self.visible = false
		emit_signal("just_died")
	
func buff(var stat : String, var mult:float):
	pass
