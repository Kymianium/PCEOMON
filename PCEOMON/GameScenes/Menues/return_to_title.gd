extends Control


# Añade el pceomon a la party si no está y lo elimina si está
func manage_party(pceomon):
	if not (pceomon in metadata.party):
		metadata.party.append(pceomon)
		var text = $"CenterContainer/Text&Button/Miscelaneous/Party".text
		text = text + ' ' + pceomon
		$"CenterContainer/Text&Button/Miscelaneous/Party".text = text
	else:
		metadata.party.erase(pceomon)
		var text = $"CenterContainer/Text&Button/Miscelaneous/Party".text
		text = text.replace(' ' + pceomon,"")
		$"CenterContainer/Text&Button/Miscelaneous/Party".text = text
	print(metadata.party)

func _on_Button_pressed():
	get_tree().change_scene("res://Title/TitleScreen.tscn")


func _on_Start_pressed():
	get_tree().change_scene("res://GameScenes/CombatScenes/CombatTemporary.tscn")


func _on_Armada_pressed():
	#manage_party("Armada")
	$"CenterContainer".visible = false
	$"ArmadaInfo".visible = true
	pass


func _on_Alparko_pressed():
	#manage_party("Alparko")
	pass
