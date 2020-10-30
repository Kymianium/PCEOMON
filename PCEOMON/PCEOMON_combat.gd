extends Skeleton2D

var foes = []
var actual_hp : int
var max_hp : int
var actual_stamina : int
var next_attack_required_stamina : int
export(String) var avatar_path

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

func _process(_delta):
	if (actual_hp <= 0):
		return
	elif(actual_stamina == next_attack_required_stamina):
		attack()
		actual_stamina = 0
	elif (metadata.time_exists.size() == 0):
		actual_stamina = actual_stamina + 1
		$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina


func damage(var damage : int):
	actual_hp = actual_hp - damage
	$"StatsSummary/HP".value = actual_hp*100/max_hp
	if(actual_hp <= 0):
		self.visible = false
		emit_signal("just_died")
	
