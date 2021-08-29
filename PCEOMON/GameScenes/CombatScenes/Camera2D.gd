extends Camera2D


const DEFAULT_X = 320
const DEFAULT_Y = 240


const X_ZOOM = 0.4
const Y_ZOOM = 0.4
const ZOOM = Vector2(X_ZOOM,Y_ZOOM)

const Y_OFFSET = 100
const X_OFFSET = 0
const OFFSET = Vector2(X_OFFSET,Y_OFFSET)


var zooming = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(DEFAULT_X,DEFAULT_Y)
	zoom = Vector2(1,1)
	current = false

func zoom_PCEOMON(pceomon):
	current = true
	position = pceomon.position + OFFSET
	zoom = ZOOM
	zooming = true
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
