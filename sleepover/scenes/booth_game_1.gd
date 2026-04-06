extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade
@onready var label = $top/label

#help
@onready var cursor = $Cursor
@onready var cam = $Camera2D
@onready var jane = $Jane
@onready var id = $ID
@onready var id_A = $ID/CollisionShape2D
@onready var scanner = $Scanner

@onready var movement_texture = $movement

@onready var beep = $sfx/beep
@onready var wind = $sfx/wind

@onready var window_animation = $window
@onready var window = $Window
@onready var window_A = $Window/CollisionShape2D

@onready var leave_QA_area = $leave_QA/CollisionShape2D
@onready var leave_QA = $leave_QA

@onready var buzzer = $Buzzer
@onready var buzzer_A = $Buzzer/CollisionShape2D
@onready var buzzer_sfx = $sfx/buzzer

@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

@onready var stinger = $Scare/scare
@onready var scare1 = $Scare

@onready var screen_image = $top/screen_image
@onready var computer_filter = $top/computer_filter
@onready var computer_interact = $Computer

#handssssss
@onready var hand = $top/hand
var holding := false
var id_insert = preload("res://images/test/card_insert.png")
var id_hold = preload("res://images/test/card_take.png")

var talking = false
var follow = false
var processing = false
var door_open = false
var scared_1 = false

var screen = preload("res://scenes/computerscreen.tscn").instantiate()


signal putdown
signal pickup
signal giveback

signal finished

func _ready() -> void:
	screen_image.hide()
	leave_QA.hide()
	leave_QA_area.disabled = true
	id_A.disabled = true
	
	await wait(2.0)
	fadeAnimation.play("fadein")
	await fadeAnimation.animation_finished
	fadeColor.hide()
	#
	#await speak("", "Those [shake]extreme measures[/shake] he mentioned...", "","","")
	#await speak("", "Not a big fan.                            ", "","","")
	#await speak("", "Anyways, I came here for a reason.", "","","")
	#await speak("", "The game plan is in my notebook.", "","","")
	#
	#e()
	follow = true
	
	card_sequence()
	await finished
	
	await wait(15.0)
	
	card_sequence()
	await finished
	

func _process(delta: float) -> void:
	
	if computer_filter.visible == true:
		if Input.is_action_just_pressed("space"):
			computer_screen_off()
	
	
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
			wind.play()
	
	elif id.overlaps_area(cursor): ### Debug plsss
		
		if holding and processing: 
			# when you're holding the card but also already scanned it and now in the checking phase
			interact("Give back?")
			if Input.is_action_just_pressed("click"):
				emit_signal("giveback")
				id_A.disabled = true
				return
		
		else:
			# when you're starting process by grabbing the ID and later scanning it
			interact("Take ID?")
			if Input.is_action_just_pressed("click"): #turns off the id button and starts the texture process
				id_A.disabled = true 
				card_holding() #though this is texture, it's not initating the next step.
				#That would be when the scanner is clicked!!!!!!!! lol
	elif computer_interact.overlaps_area(cursor): ### Debug plsss
		# when you're starting process by grabbing the ID and later scanning it
		interact("Open PC?")
		if Input.is_action_just_pressed("click"): #turns off the id button and starts the texture process
			computer_screen_on()
			
			
	elif leave_QA.overlaps_area(cursor):
		interact("Tell them to git?")
		
		if Input.is_action_just_pressed("click"):
			
			talking = true
			
			await speak("", "Should I tell him to get lost?","Yep.", "[wave]Check again.", "")
			if t.choice == 1:
				t._emote("sam","derp")
				await speak("You", "Sorry man, you gotta go.","", "", "")
				t._emote("","")
				await get_lost()
			
			e()
			
	elif scanner.overlaps_area(cursor): 
		if holding:
			interact("Scan ID?")
		if not holding or processing:
			interact("Scanner")
			if Input.is_action_just_pressed("click"):
				beep.play()
			return #stops here if not holding card for scan, so it wont reach if clicked event
		
		if Input.is_action_just_pressed("click"): #when holding card and scanner clicked, temp turn off the default button
			#starting the rest of the checking process again
			if processing: #cancel if already checking or the card is scanned already
				return
			
			processing = true # you are now checking
			id_A.disabled = true 
			# ^^^^^ this button (for giving and taking) is turned off for small bugs, so no biggie on this
			scan() #rest of scan process!
			
	elif buzzer.overlaps_area(cursor): 
		interact("Open the gatesss!")
		
		if Input.is_action_just_pressed("click"): #when holding card and scanner clicked, temp turn off the default button
			if !processing:
				talking = true
				
				if holding:
					await speak("","I haven't scanned the card yet, dummy.","","","")
				else:
					await speak("","Nobody's waiting, so no.","","","")
				
				e()
				return
				
			elif holding:
				talking = true
				
				await speak("","I have to hand it back.","","","")
				
				e()
				return
			
			await come_in()
	
	elif scare1.overlaps_area(cursor): 
		
		if scared_1:
			return
		scared_1 = true
		stinger.play()
		
		
	else:
		interact("")
		label.show()
	

func computer_screen_on():
	screen_image.show()
	computer_filter.show()
	
	talking = true
	


func computer_screen_off():
	screen_image.hide()
	computer_filter.hide()
	e()

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
	
func scan(): # basically the scanner function when clicked
	if !holding: # just checking if holding or not
		return
	
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
	#basically did the texture with the help of the card_holding function

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
@onready var gate_o = $sfx/gate_open
@onready var gate_c = $sfx/gate_close

func card_sequence(): #main function for scanning, though it's more indirect than direct
	#doin prelims, for reseting possibly idk
	leave_QA_area.disabled = true
	id_A.disabled = true
	leave_QA.hide()
	
	#start with car driving up
	d_up.play()
	
	#then wait and then stick hand out for id
	await wait(3.0)
	movement_texture.texture = null #CHANGE THIS TO THE UPDATED TEXTURE
	id_A.disabled = false
	
	#then grab, scan, and giveback
	await giveback
	leave_QA.show()
	leave_QA_area.disabled = false # turns on choice to tell him to leave 
	
	
	#then check computer screen for clearance (5), license, weight (cars get 3,000 pounds, trucks get 8,000)
	#then log them in log book
	#then buzz them in and they drive in w/ same sfx
	#or tell them to leave
	
func get_lost(driver_message:= "Dang."):
	processing = false
	talking = true
	await speak("Driver",driver_message,"","","")
	e()
	d_away.play()
	await wait(2.0)
	movement_texture.texture = null
	await d_away.finished
	
	emit_signal("finished")

func come_in(driver_message:= "Thanks."):
	processing = false
	leave_QA_area.disabled = true
	leave_QA.hide()
	buzzer_sfx.play()
	gate_o.play()
	
	talking = true
	await speak("Driver",driver_message,"","","")
	e()
	
	d_away.play()
	await wait(2.0)
	movement_texture.texture = null
	await d_away.finished
	
	gate_c.play()
	
	emit_signal("finished")


func openDoor() -> void:
	if door_open:
		return
	
	window_animation.play("door_open")
	await window_animation.animation_finished
	door_open = true
	window_A.disabled = true

#var screen
#
#func show_screen():
	#screen = preload("res://computerscreen.tscn").instantiate()
	#add_child(screen)
#
#func hide_screen():
	#screen.queue_free()
