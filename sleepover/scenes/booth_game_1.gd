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
@onready var vehicle = $car

@onready var beep = $sfx/beep
@onready var wind = $sfx/wind

@onready var window_animation = $window
@onready var window = $Window
@onready var window_A = $Window/CollisionShape2D

@onready var leave_QA_area = $leave_QA/CollisionShape2D
@onready var leave_QA = $leave_QA

@onready var buzzer = $Buzzer
@onready var buzzer_animation = $Buzzer/animation
@onready var buzzer_A = $Buzzer/CollisionShape2D
@onready var buzzer_sfx = $sfx/buzzer

@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

@onready var stinger = $Scare/scare
@onready var scare1 = $Scare

@onready var screen_image = $top/screen_image
@onready var computer_filter = $top/computer_filter
@onready var computer_interact = $Computer


@onready var d_up = $Node2D/drive_up
@onready var d_away = $Node2D/drive_away
@onready var gate_o = $sfx/gate_open
@onready var gate_c = $sfx/gate_close

@onready var clock = $Clock
@onready var clock_real = $Clock/clock


#handssssss
@onready var hand = $top/hand
var holding := false
var id_insert = preload("res://images/test/card_insert.png")
var id_hold = preload("res://images/test/card_take.png")

var car = preload("res://images/smallcar_done.png")
var car_grab = preload("res://images/smallcar_grab.png")

var truck = preload("res://images/truck_normal.png")
var truck_grab = preload("res://images/truck_grab.png")

var VEHICLE_CHOICE = ""

var talking = false
var follow = false
var processing = false
var door_open = false
var scared_1 = false

var clock_spoke = false

var GRADED_CHOICE : bool
var STRIKES = 3
var CURRENT_PERSON := 1

var screen = preload("res://scenes/computerscreen.tscn").instantiate()


signal putdown
signal pickup
signal giveback

signal finished

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	screen_image.day = 1
	screen_image.person = 0
	screen_image.hide()
	leave_QA.hide()
	leave_QA_area.disabled = true
	id_A.disabled = true
	
	await wait(2.0)
	fadeAnimation.play("fadein")
	await fadeAnimation.animation_finished
	fadeColor.hide()
	talking = true
	
	await speak("", "Those [shake]extreme measures[/shake] he mentioned...", "","","")
	await speak("", "Big yikes.", "","","")
	await speak("", "I should try my best to [pulse]avoid [/pulse]that. ", "","","")
	await speak("", "I didn't work hard getting this just to have to deal with that.", "","","")
	await speak("", "The game plan is in my notebook.", "","","")
	
	e()
	follow = true
	
	
	# 1
	VEHICLE_CHOICE = "car"
	card_sequence()
	
	await d_up.finished
	screen_image.current_weight = 3050
	
	await wait(1.0)
	
	if not talking:
		talking = true
		await speak("","Hey man it's late, can you move it?","","","")
		e()
	
	await finished
	match GRADED_CHOICE: #just find where it's false, and it will hold it against you
		false:
			STRIKES = STRIKES - 1
	# 
	
	await wait(15.0)
	
	# 2
	VEHICLE_CHOICE = "truck"
	card_sequence()
	
	await d_up.finished
	screen_image.current_weight = 8102
	
	await finished
	match GRADED_CHOICE: #just find where it's false, and it will hold it against you
		true:
			STRIKES = STRIKES - 1
	# 
	
	await wait(30.0)
	
	# 3
	VEHICLE_CHOICE = "car"
	card_sequence()
	
	await d_up.finished
	screen_image.current_weight = 3245
	
	
	await finished
	match GRADED_CHOICE: #just find where it's false, and it will hold it against you
		false:
			STRIKES = STRIKES - 1
	#
	
	day_done()

func _process(delta: float) -> void:
	
	
	if computer_filter.visible == true:
		
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		if Input.is_action_just_pressed("space"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
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
				
				match VEHICLE_CHOICE:
					"car":
						vehicle.texture = car
					"truck":
						vehicle.texture = truck
						
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
			
			await speak("", "Should I tell them to get lost?","Yep.", "[wave]Check again.", "")
			if t.choice == 1:
				t._emote("sam","derp")
				await speak("You", "Sorry, you gotta go. I don't make the rules.","", "", "")
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
				
				talking = true
				await speak("","It's pretty bulky.","","","")
				await speak("","You'd think an advanced company lab place would have better security equipment.","","","")
				await speak("","Though I guess that's where I come in. [wave]With my very special skill set.","","","")
				e()
				
			return #stops here if not holding card for scan, so it wont reach if clicked event
		
		if Input.is_action_just_pressed("click"): #when holding card and scanner clicked, temp turn off the default button
			#starting the rest of the checking process again
			if processing: #cancel if already checking or the card is scanned already
				return
			
			screen_image.person = CURRENT_PERSON
			CURRENT_PERSON = CURRENT_PERSON +1
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
	
	elif clock.overlaps_area(cursor): 
		interact("Clock")
		
		if Input.is_action_just_pressed("click"): #when holding card and scanner clicked, temp turn off the default button
			talking = true
			if not clock_spoke:
				clock_spoke = true
				await speak("", "What a nice clock.", "","","")
				await speak("", "It would be shame to just leave it here.", "","","")
				await speak("", "I do need a clock.", "","","")
				await speak("", "[shake]No one would miss it.", "","","")
				await speak("", "...", "","","")
			elif clock_spoke:
				await speak("", "I might take this later...", "","","")
			
			
			e()
	
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




func card_sequence(): #main function for scanning, though it's more indirect than direct
	vehicle.texture = null
	#doin prelims, for reseting possibly idk
	leave_QA_area.disabled = true
	id_A.disabled = true
	leave_QA.hide()
	
	#start with car driving up
	d_up.play()
	
	#then wait and then stick hand out for id
	await wait(2.0)
	
	match VEHICLE_CHOICE:
		"car":
			vehicle.texture = car
		"truck":
			vehicle.texture = truck
	await wait(4.0)
	
	match VEHICLE_CHOICE:
		"car":
			vehicle.texture = car_grab
		"truck":
			vehicle.texture = truck_grab
			
	id_A.disabled = false
	
	#then grab, scan, and giveback
	await giveback
	leave_QA.show()
	leave_QA_area.disabled = false # turns on choice to tell him to leave 
	await finished
	leave_QA_area.disabled = true
	clock_real.time = clock_real.time + 1
	
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
	vehicle.texture = null
	await d_away.finished
	
	screen_image.current_weight = 0
	GRADED_CHOICE = false
	emit_signal("finished")

func come_in(driver_message:= "Thanks."):
	processing = false
	leave_QA_area.disabled = true
	leave_QA.hide()
	buzzer_sfx.play()
	gate_o.play()
	
	
	buzzer_animation.play("interact")
	talking = true
	await speak("Driver",driver_message,"","","")
	e()
	
	d_away.play()
	await wait(2.0)
	vehicle.texture = null
	
	await d_away.finished
	
	gate_c.play()
	screen_image.current_weight = 0
	GRADED_CHOICE = true
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

func day_done():
	print(STRIKES)
	await wait(2.0)
	
	$top/RichTextLabel.show()
