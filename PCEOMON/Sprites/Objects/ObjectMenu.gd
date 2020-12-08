extends Control


var numObjects = 0
var objectsDescription = {}
var objectsTexture = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	numObjects = 6
	var x = 20
	var y = 20
	getObjects()
	for object in objectsDescription.keys():
		var sprite = TextureButton.new()
		sprite.expand
		sprite.texture_normal = objectsTexture[object]
		var name = Label.new()
		name.text = object
		var contenedor = HBoxContainer.new()
		contenedor.add_child(sprite)
		contenedor.add_child(name)
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
