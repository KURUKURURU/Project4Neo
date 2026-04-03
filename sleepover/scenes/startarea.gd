extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade

@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

@onready var cutsceneA = $cutsceneA
@onready var bikeSFX = $bike

#AREAS
@onready var benny = $benny/Area2D
@onready var benny_C = $benny/Area2D/CollisionShape2D
@onready var ENTER = $ENTER
@onready var ENTER_C = $ENTER/CollisionShape2D

var talking = false
var talk_benny = false
var enter_vant = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ENTER.monitoring = false
	#p.last_action = "l"
	
	cutscene("RESET")
	fadeAnimation.play("fadein")
	
	t._emote("", "")
	await speak("", "Bike locked.", "", "", "")
	bikeSFX.play()
	e()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	p.talking = talking
	
	if !talking:
		if pArea.overlaps_area(benny):
			p.can_interact = true
			if Input.is_action_just_pressed("interact"):
				
				p.can_interact = false
				print("debug")
				talking = true
				t._emote("benny", "normal")
				await speak("...", "Good evening.", "", "", "")
				t._emote("sam", "normal")
				await speak("You", "Hey Benny.", "", "", "")
				t._emote("benny", "normal")
				await speak("Benny", "Another job?", "", "", "")
				t._emote("sam", "normal")
				await speak("You", "Another job.", "", "", "")
				t._emote("", "")
				benny_C.disabled = true
				ENTER_C.disabled = false
				e()
				
				await cutscene("move_away")
				
				t._emote("benny", "normal")
				
				
				
				talking = false
			
		elif pArea.overlaps_area(ENTER):
			p.can_interact = true
			
			if Input.is_action_just_pressed("interact"):
				ENTER_C.disabled = true
				
				talking = true
				p.can_interact = false
				
				await speak("Benny", "You are good guy.", "", "", "")
				
				p.last_action = "d"
				#p.last_action = ""
				
				await p.emote_icon("exclamation")
				t._emote("sam", "derp")
				await speak("You", "Thanks?", "", "", "")
				t._emote("benny", "normal")
				await speak("Benny", "You should get real job, not crap made for bums.", "", "", "")
				
				t._emote("sam", "normal")
				await speak("You", "That's probably the nicest thing you've ever said to me.", "", "", "")
				await speak("You", "And that might be the first positive thing you've said since we met last year.", "", "", "")
				await speak("You", "When you said bums, does that imply that you're a bum?", "", "", "")
				speak("You", "Hope you know I dont think-", "", "", "")
				await wait(1.0)
				t._emote("benny", "normal")
				await speak("Benny", "Go in.", "", "", "")
				
				p.last_action = "l"
				
				t._emote("sam", "derp")
				await speak("You", "Sorry.", "", "", "")
				t._emote("sam", "sad")
				await speak("You", "Don't worry, this'll be the last job for a while.", "", "", "")
				
				e()
				talking = false
				
				fadeAnimation.play("fade")
				await fadeAnimation.animation_finished
				get_tree().change_scene_to_file("res://scenes/kitchen.tscn")
		else:
			p.can_interact = false


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
