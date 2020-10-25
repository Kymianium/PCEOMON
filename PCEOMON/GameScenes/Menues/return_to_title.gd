extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://Title/TitleScreen.tscn")


func _on_Start_pressed():
	get_tree().change_scene("res://GameScenes/CombatScenes/CombatTemporary.tscn")


func _on_Armada_pressed():
	metadata.party.append("Armada")
	var text = $"CenterContainer/Text&Button/Miscelaneous/Party".text
	text = text + ' Armada'
	$"CenterContainer/Text&Button/Miscelaneous/Party".text = text
