extends Node2D

func _ready():
	$Animation.play("CoffeeBoost")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Animation_animation_finished():
	self.queue_free()
