extends Control

signal text(text)

var atk1
var atk2
var atk3
var atk4
var passive

onready var current = $CombatGUI/Fight

func _on_Fight_pressed():
	change_visible($CombatGUI/Fight)
	

func _on_Data_pressed():
	change_visible($CombatGUI/Data)


func _on_Objects_pressed():
	change_visible(get_parent().get_node("ObjectMenu"))

func change_visible(var path):
	current.visible = false
	current = path
	current.visible = true




func _on_Atk1_pressed():
	emit_signal("text", atk1)


func _on_Atk2_pressed():
	emit_signal("text", atk2)

func _on_Atk3_pressed():
	emit_signal("text", atk3)

func _on_Atk4_pressed():
	emit_signal("text", atk4)

func _on_Passive_pressed():
	emit_signal("text", passive)

