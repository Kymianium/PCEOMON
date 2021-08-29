extends Camera2D


const DEFAULT_X = 320
const DEFAULT_Y = 240


const X_ZOOM = 0.4
const Y_ZOOM = 0.4
const ZOOM = Vector2(X_ZOOM,Y_ZOOM)

const Y_OFFSET = 100
const X_OFFSET = 0
const OFFSET = Vector2(X_OFFSET,Y_OFFSET)
const ZOOM_SPEED = 2

var smooth_zoom = Vector2(1,1)
var zooming = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(DEFAULT_X,DEFAULT_Y)
	zoom = Vector2(1,1)

func zoom_PCEOMON(pceomon):
	smooth_zoom = Vector2(1,1)
	position = pceomon.position + OFFSET
	zooming = true
	
	
func _process(delta):
	if zooming:
		smooth_zoom = lerp(smooth_zoom, ZOOM, ZOOM_SPEED * delta)
		if smooth_zoom != ZOOM:
			zoom = smooth_zoom
		else:
			zooming = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
