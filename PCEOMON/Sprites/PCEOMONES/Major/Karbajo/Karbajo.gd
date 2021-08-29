extends "res://PCEOMONES_classes/Alcoholic.gd"


func _ready():
	$HBoxContainer/StatsSummary/Shield.value = 0
	arrow = $Arrow
	maxalcohol = 500
	alcohol = 0
	name = "Karbajo"
	ability = "D. Caníbal"
	attack1 = "Mordisco"
	attack2 = "Lectura"
	attack3 = "Chute"
	attack4 = "Octane"
	type = "Alcohólico"
	._ready()
	avatar_path = "res://Sprites/PCEOMONES/Major/Karbajo/Karbajo_avatar.png"
	
func next1():
	next_attack_required_stamina = 200
	select_combat("Cómo se me antoja clavar la dentadura... [shake level=10]¿SOBRE QUIÉN LO HARÉ?[/shake]",ENEMY)
	.next1()
func next2():
	next_attack_required_stamina = 200
	.next2()
func next3():
	next_attack_required_stamina = 150
	.next3()
func next4():
	next_attack_required_stamina = 250
	select_combat("Selecciona una víctima de las habilidades de Karbajo en la Liga de Cohetes",ENEMY)
	.next4()
func atk1():
	unicast_damage(500,0.5, PHYSICAL_DMG, targets,"Mordisco","¡OH, DIOS! ¡¿ES UN BRAZO ESO QUE LLEVA KARBAJO EN LA BOCA?!")
	.atk1()
func atk2():
	permanent_buff([self], [CHEMICAL_DMG, PHYSICAL_DMG,PSYCHOLOGYCAL_DMG,CHEMICAL_DFC,PHYSICAL_DFC,PSYCHOLOGYCAL_DFC,SPEED], 1/(1 + (alcohol/maxalcohol)*3), 0)
	if alcohol>100:
		alcohol-=100
	else:
		alcohol=0
	permanent_buff([self], [CHEMICAL_DMG, PHYSICAL_DMG,PSYCHOLOGYCAL_DMG,CHEMICAL_DFC,PHYSICAL_DFC,PSYCHOLOGYCAL_DFC,SPEED], 1 + (alcohol/maxalcohol)*3, 0)
	$"HBoxContainer/StatsSummary/Alcohol".value = float(alcohol)/maxalcohol *100
	emit_signal("just_attacked", "Karbajo", "Lectura", "", "La verdad, después de 2000 páginas de Brandon Sanderson, se queda uno como nuevo.")
	.atk2()

func atk3():
	permanent_buff([self], [CHEMICAL_DMG, PHYSICAL_DMG,PSYCHOLOGYCAL_DMG,CHEMICAL_DFC,PHYSICAL_DFC,PSYCHOLOGYCAL_DFC,SPEED], 1/(1 + (alcohol/maxalcohol)*3), 0)
	alcohol+=70
	if alcohol>maxalcohol:
		alcohol=maxalcohol
	permanent_buff([self], [CHEMICAL_DMG, PHYSICAL_DMG,PSYCHOLOGYCAL_DMG,CHEMICAL_DFC,PHYSICAL_DFC,PSYCHOLOGYCAL_DFC,SPEED], 1 + (alcohol/maxalcohol)*3, 0)
	
	$"HBoxContainer/StatsSummary/Alcohol".value = float(alcohol)/maxalcohol *100
	$"SpriteContainer/AnimatedSprite".animation = "chute"
	emit_signal("just_attacked", "Karbajo", "Chute", "", " [shake level=10]D R O G A . . .       \nC A N Í B A L . . .[/shake]")
	.atk3()

func atk4():
	unicast_damage(200,0, PSYCHOLOGYCAL_DMG, targets,"Octane","Arranca por la banda izquierda el genio del Rocket mundial... ¡Esta vez tampoco decepciona!")
	.atk4()	
