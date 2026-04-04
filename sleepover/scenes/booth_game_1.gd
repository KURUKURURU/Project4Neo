extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade

@onready var cursor = $Cursor
@onready var jane = $Jane

var talking = false

var cursor_image

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeAnimation.play("fadein")
	await fadeAnimation.animation_finished
	fadeColor.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cursor.global_position = get_global_mouse_position()
	Input.set_custom_mouse_cursor(cursor_image)
	
	if talking:
		return
	
	if jane.overlaps_area(cursor):
		set_cursor("interact_cursor")
		
		if Input.is_action_just_pressed("click"):
			pass
	else:
		set_cursor("normal_cursor")

func set_cursor(thing):
	match thing:
		"normal_cursor":
			cursor_image = load("res://images/cursor/normal_cursor.png")
		"interact_cursor":
			cursor_image = load("res://images/cursor/cursor_interact.png")
