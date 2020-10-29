extends Skeleton2D

var foes = []
var actual_hp : int
var max_hp : int
var actual_stamina : int
var next_attack_required_stamina : int

signal just_died
#############################
###########PRUEBAS###########
func _ready():
	actual_stamina = 0
	next_attack_required_stamina = 10000
	max_hp = 100
	actual_hp = max_hp

func attack():
	metadata.time_exists = metadata.time_exists + 1
#############################

func _process(_delta):
	if (actual_hp <= 0):
		return
	elif(actual_stamina == next_attack_required_stamina):
		#metadata.time_exists = false
		attack()
		actual_stamina = 0
	elif (metadata.time_exists == 0):
		actual_stamina = actual_stamina + 1
		$"StatsSummary/Stamina".value = actual_stamina*100/next_attack_required_stamina


func damage(var damage : int):
	actual_hp = actual_hp - damage
	$"StatsSummary/HP".value = actual_hp*100/max_hp
	if(actual_hp <= 0):
		self.visible = false
		emit_signal("just_died")
	
