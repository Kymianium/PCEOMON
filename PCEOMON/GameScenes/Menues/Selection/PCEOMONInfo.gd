extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var minor : bool = false

var AbDesc
var At1Desc
var At2Desc
var At3Desc
var At4Desc

signal volver
signal seleccionar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Volver_pressed():
	emit_signal("volver")


func _on_Seleccionar_pressed():
	emit_signal("seleccionar")


func _on_AbName_pressed():
	$"RequestedData/SpriteName/Name".text = $"Scroll/VBoxGlobal/AbilityAttacks/Ability/AbName".text
	$"RequestedData/Data".text = AbDesc
	$Control.visible = false
	$Scroll.visible = false
	$RequestedData.visible = true


func _on_At1Name_pressed():
	$"RequestedData/SpriteName/Name".text = $"Scroll/VBoxGlobal/AbilityAttacks/Attack1/At1Name".text
	$"RequestedData/Data".text = At1Desc
	$Control.visible = false
	$Scroll.visible = false
	$RequestedData.visible = true


func _on_At2Name_pressed():
	$"RequestedData/SpriteName/Name".text = $"Scroll/VBoxGlobal/AbilityAttacks/Attack2/At2Name".text
	$"RequestedData/Data".text = At2Desc
	$Control.visible = false
	$Scroll.visible = false
	$RequestedData.visible = true


func _on_At3Name_pressed():
	$"RequestedData/SpriteName/Name".text = $"Scroll/VBoxGlobal/AbilityAttacks/Attack3/At3Name".text
	$"RequestedData/Data".text = At3Desc
	$Control.visible = false
	$Scroll.visible = false
	$RequestedData.visible = true


func _on_At4Name_pressed():
	$"RequestedData/SpriteName/Name".text = $"Scroll/VBoxGlobal/AbilityAttacks/Attack4/At4Name".text
	$"RequestedData/Data".text = At4Desc
	$Control.visible = false
	$Scroll.visible = false
	$RequestedData.visible = true


func _on_Data_Volver_pressed():
	$Control.visible = true
	$Scroll.visible = true
	$RequestedData.visible = false
