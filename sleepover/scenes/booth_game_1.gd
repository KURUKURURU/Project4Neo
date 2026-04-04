extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade
@onready var label = $top/label

@onready var cursor = $Cursor
@onready var cam = $Camera2D
@onready var jane = $Jane
@onready var id = $ID
@onready var id_A = $ID/CollisionShape2D

@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

#handssssss
@onready var hand = $top/hand
var holding := false
var id_insert = preload("res://images/test/card_insert.png")
var id_hold = preload("res://images/test/card_take.png")

var talking = false
var follow = false

signal putdown

func _ready() -> void:
	await wait(2.0)
	fadeAnimation.play("fadein")
	await fadeAnimation.animation_finished
	fadeColor.hide()
	
	await speak("", "He was very direct on how protective I should be of the facility.", "","","")
	await speak("", "Though, I'm not going to be a big fan of those methods.", "","","")
	await speak("", "I came here for a reason.", "","","")
	e()
	follow = true

func _process(delta: float) -> void:
	
	if follow:
		label.show()
		cam.global_position = get_global_mouse_position()
	else:
		label.hide()
		
	cursor.global_position = get_global_mouse_position()
	
	if talking:
		label.hide()
		follow = false
		return
	
	if jane.overlaps_area(cursor):
		interact("Woman")
		
		if Input.is_action_just_pressed("click"):
			pass
			
	if id.overlaps_area(cursor):
		interact("Identification")
		
		if Input.is_action_just_pressed("click"):
			id_A.disabled = true
			card_holding()
			
	else:
		interact("")
		label.show()
		

func interact(text):
	label.text = "[shake]" + text 

func card_holding():
	holding = true
	hand.texture = id_hold
	await putdown
	hand.texture = null

func Woman() -> void:
	talking = true
	await speak("", "There's someone over there.","", "", "")
	await speak("", "Nice to know I'm not alone, though that could be bad too.","", "", "")
	await speak("", "Wonder how she got the job.","", "", "")
	e()
	
	talking = false

func speak(n, m, c1, c2, c3):
	await t._speak(n, m, c1, c2, c3)

func e():
	t._end()
	follow = true
	talking = false
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
