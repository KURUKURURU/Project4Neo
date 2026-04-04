extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade
@onready var label = $top/label

@onready var cursor = $Cursor
@onready var cam = $Camera2D
@onready var jane = $Jane

@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

var talking = false
var pause = false

var cursor_image
var current_cursor_state = ""

func _ready() -> void:
	
	pause = true
	
	await wait(2.0)
	fadeAnimation.play("fadein")
	await fadeAnimation.animation_finished
	fadeColor.hide()
	pause = false
	
	await speak("", "He was very direct on how protective I should be of the facility.", "","","")
	await speak("", "Though, I'm not going to be a big fan of those methods.", "","","")
	await speak("", "I came here for a reason.", "","","")
	e()
	

func _process(delta: float) -> void:
	
	if !talking and !pause:
		label.show()
		cam.global_position = get_global_mouse_position()
	else:
		label.hide()
		
	cursor.global_position = get_global_mouse_position()
	
	if talking:
		return
	
	if jane.overlaps_area(cursor):
		interact("Woman")
		
		if Input.is_action_just_pressed("click"):
			pass
	else:
		interact("")

func interact(text):
	label.text = "[shake]" + text 



func Woman() -> void:
	talking = true
	await speak("", "There's a woman over there.","", "", "")
	await speak("", "She must've been approached like I had.","", "", "")
	e()
	
	talking = false

func speak(n, m, c1, c2, c3):
	await t._speak(n, m, c1, c2, c3)

func e():
	t._end()
	talking = false
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
