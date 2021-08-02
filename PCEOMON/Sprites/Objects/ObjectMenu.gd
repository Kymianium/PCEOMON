extends Control

var selected

signal target_selected
signal object_selected(item,target)
signal announcement(announce)



var numObjects = 0
var objectsDescription = {}
var objectsTexture = {}
var selecting
var target

const ITEM = preload("res://GameScenes/Menues/Miscelaneous/Item.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	numObjects = 6
	getObjects()
	for nombre in objectsDescription.keys():
		var contenedor = ITEM.instance()
		contenedor.setTexture(objectsTexture[nombre])
		contenedor.setName(nombre)
		contenedor.connect("itemDescription", self, "showText")
		$"Items/Objetos".add_child(contenedor)

func getObjects():
	var i = 0
	var file = File.new()
	file.open("res://Sprites/Objects/Objects.txt", File.READ)
	while i < numObjects:
		var name = file.get_line().replace("\\n","\n")
		metadata.objects += [name]
		objectsDescription[name] = file.get_line().replace("\\n","\n")
		objectsTexture[name] = load("res://Sprites/Objects/ObjectSprites/"+name+".png")
		i += 1
		
		
func showText(show, name):
	if show:
		$"Texto".text = objectsDescription[name] 
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
