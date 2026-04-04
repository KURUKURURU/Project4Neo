extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade

@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui
@onready var sprite = $top/talking_ui/Sprite

#@onready var cutsceneA = $cutsceneA
#@onready var bikeSFX = $bike

#AREAS
@onready var start = $start
#@onready var move_backC = $move_back/CollisionShape2D
#@onready var benny = $benny/Area2D
#@onready var benny_C = $benny/Area2D/CollisionShape2D
#@onready var ENTER = $ENTER
#@onready var ENTER_C = $ENTER/CollisionShape2D

var talking = false
var talk_benny = false
var enter_vant = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeAnimation.play("fadein")
	p.moving = false
	p.last_action = "d"
	talking = true
	p.can_interact = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	p.talking = talking
	
	#if pArea.overlaps_area(move_back):
		#await cutscene("move_away")
		#benny_C.disabled = false
		#move_backC.disabled = true
	#
	if !talking:
		if pArea.overlaps_area(start):
			p.can_interact = true
			if Input.is_action_just_pressed("interact"):
				t._emote("", "")
				await speak("", "Start Shift?", "[wave]Agh.", "[shake]Yes...", "")
				if t.choice == 1:
					pass
				elif t.choice == 2:
					get_tree().change_scene_to_file("uid://b1tukiw0ew1lj")
				e()
				
				talking = false
			#
		#elif pArea.overlaps_area(ENTER):
			#p.can_interact = true
			#
			#if Input.is_action_just_pressed("interact"):
				#pass
				##
		else:
			p.can_interact = false


func speak(n, m, c1, c2, c3):
	p.moving = false
	await t._speak(n, m, c1, c2, c3)
	p.moving = true

func e():
	t._end()
	talking = false

			
#func cutscene(animation):
	#cutsceneA.play(animation)
	#await cutsceneA.animation_finished

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _BIKE_DONE() -> void:
	t._emote("sam", "normal")
	await speak("You", "I hope no one saw me riding uphill.", "", "", "")
	t._emote("sam", "smile2")
	await speak("You", "[tornado]That wasn't pretty[/tornado][shake]....", "", "", "")
	e()
