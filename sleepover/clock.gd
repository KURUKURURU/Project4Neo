extends Node2D

@onready var img = $img

@export var time := 11

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	var frank = "res://images/clock/" + str(time) + ".png"
	img.texture = load(frank)
	
