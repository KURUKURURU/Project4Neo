extends Control
@onready var all = $animation
@onready var text = $text
@onready var icon = $icon
@onready var n 
@onready var h 
@onready var d 

@export var display : String
@export var design : int
signal activate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all.play("dead")
	
	if design == 1:
		n = preload("res://images/action2/1n.png")
	if design == 2:
		n = preload("res://images/action2/2n.png")
	else:
		n = preload("res://images/action/normal.png")
		
	icon.texture = n

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text.text = display
	
	if display == "" or display == null:
		self.hide()
	else:
		self.show()
		
	
	if design == 1:
		n = preload("res://images/action2/1n.png")
		h = preload("res://images/action2/1h.png")
		d = preload("res://images/action2/1n.png")
	if design == 2:
		n = preload("res://images/action2/2n.png")
		h = preload("res://images/action2/2h.png")
		d = preload("res://images/action2/2n.png")
	else:
		n = preload("res://images/action/normal.png")
		h = preload("res://images/action/hover.png")
		d = preload("res://images/action/down.png")

#

func hover() -> void:
	icon.texture = h
	all.play("awaken")

func unhover() -> void:
	icon.texture = n
	all.play("kill")
	await all.animation_finished
	all.play("dead")

func press() -> void:
	$click.play()
	icon.texture = d
	await wait(0.1)
	icon.texture = h
	emit_signal("activate")

func wait(seconds):
	await get_tree().create_timer(seconds).timeout
