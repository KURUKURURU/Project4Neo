extends Node2D
@export var sprite: String
@export var emote: String

@onready var image = $ColorRect/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !(emote == "") and !(name == ""):
		var combo = str(sprite) + "_" + emote + ".png"
		image.texture = load("res://images/sprites/" + str(combo))
	else:
		image.texture = null
		#image.texture = load("res://images/sprites/empty.png")
		
	
		
