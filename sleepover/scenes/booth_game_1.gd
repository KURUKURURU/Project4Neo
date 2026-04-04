extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade
@onready var label = $top/label

@onready var cursor = $Cursor
@onready var cam = $Camera2D
@onready var jane = $Jane
@onready var id = $ID
@onready var id_A = $ID/CollisionShape2D
@onready var scanner = $Scanner
@onready var movement_texture = $movement
@onready var beep = $beep

@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

#handssssss
@onready var hand = $top/hand
var holding := false
var id_insert = preload("res://images/test/card_insert.png")
var id_hold = preload("res://images/test/card_take.png")

var talking = false
var follow = false
var processing = false

signal putdown
signal pickup
signal giveback

func _ready() -> void:
	id_A.disabled = false
	await wait(2.0)
	fadeAnimation.play("fadein")
	await fadeAnimation.animation_finished
	fadeColor.hide()
	
	await speak("", "Those [shake]extreme measures[/shake] he mentioned...", "","","")
	await speak("", "Not a big fan.                            ", "","","")
	await speak("", "Anyways, I came here for a reason.", "","","")
	await speak("", "The game plan is in my notebook.", "","","")
	
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
			
	elif id.overlaps_area(cursor):
		if holding and processing:
			interact("Give back?")
		else:
			interact("Identification")
		
		if Input.is_action_just_pressed("click"):
			
			if holding and processing:
				emit_signal("giveback")
				id_A.disabled = true
				return
			
			id_A.disabled = true
			card_holding()
			
	elif scanner.overlaps_area(cursor):
		if holding:
			interact("Scan?")
		if not holding:
			interact("Scanner")
			return
		
		if Input.is_action_just_pressed("click"):
			if processing:
				return
			
			processing = true
			id_A.disabled = true
			scan()
			
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
	await pickup
	hand.texture = id_hold
	await giveback
	hand.texture = null
	holding = false 
	
func scan():
	if !holding:
		return
	if holding:
		talking = true
		emit_signal("putdown")
		movement_texture.texture = id_insert
		
		await wait(1.0)
		beep.play()
		await wait(1.0)
		
		movement_texture.texture = null
		e()
		
		emit_signal("pickup")
		
		id_A.disabled = false


func Woman() -> void:
	talking = true
	await speak("", "There's someone over there.","", "", "")
	await speak("", "Nice to know I'm not alone. ","", "", "")
	await speak("", "[wave]Though that could be bad thing too...","", "", "")
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
