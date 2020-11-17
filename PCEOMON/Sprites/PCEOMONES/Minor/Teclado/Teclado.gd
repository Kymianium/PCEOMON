extends "res://PCEOMONES_classes/MINOR.gd"

var tipo_robado = null
var selected_enemy
var selected_ally

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "Teclado"
	ability = "Snippet"
	attack1 = "Ctrl+Z"
	attack2 = "Ctrl+C"
	attack3 = "Ctrl+V"
	attack4 = "Ctrl+Alt+Suprimir"
	type = "Menor"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Minor/Teclado/Teclado_avatar.png"
	next_attack_required_stamina = 1300

func next1():
	emit_signal("announcement","Ataque no implementado")

func next2():
	next_attack_required_stamina = 500
	emit_signal("permanent_announcement", "Selecciona a un PCEOMÓN para [shake]copiarle el ataque[/shake]")
	selected_enemy = yield(select(true), "completed")
	.next2()

func next3():
	if (tipo_robado == null):
		emit_signal("announcement","¡Roba primero un ataque!")
	elif tipo_robado == "Alcohólico":
		emit_signal("permanent_announcement", "[wave]Ugh, no voy muy bien.\n¡Hombre, pero si es ...[/wave]")
		selected_enemy = yield(select(false), "completed")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func atk2():
	tipo_robado = selected_enemy.type

func atk3():
	pass

