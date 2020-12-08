extends Control


var numObjects = 0
var objectsDescription = {}
var objectsTexture = {}

const ITEM = preload("res://GameScenes/Menues/Miscelaneous/Item.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	numObjects = 6
	getObjects()
	for nombre in objectsDescription.keys():
		var contenedor = ITEM.instance()
		contenedor.setTexture(objectsTexture[nombre])
		contenedor.setName(nombre)
		contenedor.setDescription(objectsDescription[nombre])
		contenedor.connect("itemDescription", self, "showText")
		$"Objetos-Texto/Objetos".add_child(contenedor)

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
		
		
func showText(show, description):
	if show:
		$"Objetos-Texto/Texto".text = description 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
