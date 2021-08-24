extends Control

var selected

signal target_selected
signal object_selected(item,target)
signal announcement(announce)


var Fiumer		#clase preimportada para comprobar si un PCEOMON es de este tipo
var Alcoholic

var item_map = {}

var numObjects = 0
var objectsDescription = {}
var objectsTexture = {}
var selecting
var target

const ITEM = preload("res://GameScenes/Menues/Miscelaneous/Item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Texto.rect_clip_content = false		#Esto hace que no se corte la parte izquierda del texto
	for i in range(0,metadata.items.size()):
		var item_preload = load(metadata.item_paths[i])
		var item_instance = item_preload.instance()
		item_instance.connect("itemDescription", self, "showText")
		$"Items/Objetos".add_child(item_instance)
		item_map[metadata.items[i]] = funcref(item_instance,"useObject")
		item_instance.connect("announcement",self,"broadcast_announcement") #En ready(), aun no se si combatManager tiene acceso al objeto, así que conectamos la señal de announcement por aquí
	Fiumer = preload("res://PCEOMONES_classes/FIUMER.gd")
	Alcoholic = preload("res://PCEOMONES_classes/Alcoholic.gd")

#func getObjects():	
#	var i = 0
#	var file = File.new()
#	file.open("res://Sprites/Objects/Objects.txt", File.READ)
#	while i < numObjects:
#		var name = file.get_line().replace("\\n","\n")
#		metadata.objects += [name]
#		objectsDescription[name] = file.get_line().replace("\\n","\n")
#		objectsTexture[name] = load("res://Sprites/Objects/ObjectSprites/"+name+".png")
#		i += 1

func get_func_from_name(name):
	if name in item_map:
		return item_map[name]
	print("MUERTE Y DESTRUCCION EN ObjectMenu: Objecto no incluido en el mapa de Items")


		
func showText(name,description):
	$"Texto".text = description 
	selected = name

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_Volver_pressed():
	self.visible = false


func _on_Seleccionar_pressed():
	if selected != null:
		print("Seleccionando target del objecto")
		#TODO falta escoger el target
		yield(select_combat("Selecciona un PCEOMON"),"completed")
		print("Se ha sellecionado el objeto ", selected, " en el PCEOMON ", target)
		emit_signal("object_selected",selected,target)
		
	else:
		return


#Mandamos la señal del objeto hacia el combat_manager
func broadcast_announcement(message):
	emit_signal("announcement",message)


#Todo el jaleo de la seleccion

func target_selected(pceomon,boss):
	if selecting:
		target = pceomon
		emit_signal("target_selected")




func select_combat(var message : String):
	#print("select_combat")
	self.visible = false
	emit_signal("announcement", message)
	selecting = true
	yield(self,"target_selected")
	#print("Pceomon seleccionado",target)
	selecting = false
