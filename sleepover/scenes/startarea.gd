extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade

@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

@onready var cutsceneA = $cutsceneA

#AREAS
@onready var benny = $guardguy/Area2D
@onready var ENTER = $ENTER

var talking = false
var talk_benny = false
var enter_vant = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#p.last_action = "l"
	
	cutscene("RESET")
	fadeAnimation.play("fadein")
	
	t._emote("", "")
	await speak("", "Bike locked.", "", "", "")
	e()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	p.talking = talking
	
	if Input.is_action_just_pressed("interact") and !talking:
		if talk_benny:
			talking = true
			p.can_interact = false
			print("debug")
			
			t._emote("guy", "test")
			await speak("...", "Good evening.", "", "", "")
			t._emote("sam", "normal")
			await speak("You", "Hey Benny.", "", "", "")
			t._emote("guy", "test")
			await speak("Benny", "Another job?", "", "", "")
			t._emote("sam", "normal")
			await speak("You", "Another job.", "", "", "")
			t._emote("", "")
			
			benny.monitoring = false
			e()
			
			await cutscene("move_away")
			
			t._emote("guy", "test")
			
			talking = false
			
		elif enter_vant:
			talking = true
			p.can_interact = false
			
			await speak("Benny", "You are good guy.", "", "", "")
			
			p.last_action = "d"
			#p.last_action = ""
			
			await p.emote_icon("exclamation")
			t._emote("sam", "derp")
			await speak("You", "Thanks?", "", "", "")
			t._emote("guy", "test")
			await speak("Benny", "You should get real job, not crap made for bums.", "", "", "")
			
			t._emote("sam", "normal")
			await speak("You", "That's probably the nicest thing you've said to me.", "", "", "")
			await speak("You", "And that might be the first positive thing you've said since we met last year.", "", "", "")
			
			p.last_action = "l"
			
			await speak("You", "Don't worry, this'll be the last job for a while.", "", "", "")
			ENTER.monitoring = false
			
			e()
			talking = false
			
			fadeAnimation.play("fade")
			await fadeAnimation.animation_finished
			get_tree().change_scene_to_file("res://scenes/kitchen.tscn")
	


func speak(n, m, c1, c2, c3):
	p.moving = false
	await t._speak(n, m, c1, c2, c3)
	p.moving = true

func e():
	t._end()
	talking = false

			
func cutscene(animation):
	cutsceneA.play(animation)
	await cutsceneA.animation_finished
	


func Guy(area: Area2D) -> void:
	if area == pArea:
		p.can_interact = true
		talk_benny = true
		

func _ENTER(area: Area2D) -> void:
	if area == pArea:
		p.can_interact = true
		enter_vant = true
			
		
func exit(area):
	if area == pArea:
		p.can_interact = false
		talk_benny = false
		enter_vant = false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
