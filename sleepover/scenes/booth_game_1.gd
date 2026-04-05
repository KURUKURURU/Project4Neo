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
@onready var beep = $sfx/beep
@onready var window_animation = $window
@onready var window = $Window
@onready var window_A = $Window/CollisionShape2D
@onready var leave_QA_area = $leave_QA/CollisionShape2D
@onready var leave_QA = $leave_QA

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
var door_open = false

signal putdown
signal pickup
signal giveback

func _ready() -> void:
	leave_QA_area.disabled = true
	id_A.disabled = true
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
	
	elif jane.overlaps_area(cursor) and door_open:
		interact("Woman")
		
		if Input.is_action_just_pressed("click"):
			Woman()
			pass
	elif window.overlaps_area(cursor):
		interact("Open?")
		
		if Input.is_action_just_pressed("click"):
			await wait(1)
			$wind.play()
			
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
			
	elif leave_QA.overlaps_area(cursor):
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
	await speak("", "[wave]Though that could be a bad thing too...","", "", "")
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


@onready var d_up = $Node2D/drive_up
@onready var d_away = $Node2D/drive_away
#@onready var drive_away = $Node2D/drive_away

func card_sequence():
	#doin prelims
	leave_QA_area.disabled = true
	id_A.disabled = true
	
	#start with car driving up
	d_up.play()
	await d_up.finished
	
	#then wait and then stick hand out for id
	await wait(2.0)
	movement_texture.texture = null #CHANGE THIS TO THE UPDATED TEXTURE
	id_A.disabled = false
	
	#then grab, scan, and giveback
	await giveback
	leave_QA_area.disabled = false
	
	
	#then check computer screen for clearance (5), license, weight (cars get 3,000 pounds, trucks get 8,000)
	#then log them in log book
	#then buzz them in and they drive in w/ same sfx
	#or tell them to leave
	
	


func openDoor() -> void:
	if door_open:
		return
	
	window_animation.play("door_open")
	await window_animation.animation_finished
	door_open = true
	window_A.disabled = true
