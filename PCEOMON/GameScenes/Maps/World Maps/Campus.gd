extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FIUM_pressed():
	metadata.enemy_party_path = []
	metadata.enemy_party_path.append("res://Sprites/PCEOMONES/Bosses/GPantanos/GPantanos.tscn")
	metadata.ubicacion = "res://Backgrounds/Fondo PCEOMON.png"
	get_tree().change_scene("res://GameScenes/CombatScenes/CombatTemporary.tscn")


func _on_AG_pressed():
	metadata.enemy_party_path = []
	metadata.enemy_party_path.append("res://Sprites/PCEOMONES/Bosses/FedroP/FedroP.tscn")
	metadata.ubicacion = "res://Backgrounds/Aulario general.png"
	get_tree().change_scene("res://GameScenes/CombatScenes/CombatTemporary.tscn")
