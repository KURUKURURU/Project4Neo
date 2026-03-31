extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade

@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui

@onready var cutsceneA = $cutsceneA

#AREAS
@onready var benny = $guardguy/Area2D
@onready var ENTER = $ENTER

var talking = false
var talk_benny = false
var enter_vant = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cutscene("RESET")
	fadeAnimation.play("fadein")
	
	await speak("You", "I forgot to lock my bike.", "", "", "")
	t._end()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and !talking:
		if talk_benny:
			talking = true
			p.can_interact = false
			print("debug")
			await speak("Benny", "Evenin' Sam.", "", "", "")
			await speak("Benny", "You're early as usual. ", "", "", "")
			await speak("Benny", "Off to get another job, hm?", "Yup.", "", "")
			
			await cutscene("move_away")
			benny.monitoring = false
			
			await speak("Benny", "Later.", "", "", "")
			e()
			talking = false
			
		elif enter_vant:
			fadeAnimation.play("fade")
			await fadeAnimation.animation_finished
			get_tree().change_scene_to_file("res://scenes/vant_area.tscn")
	


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
