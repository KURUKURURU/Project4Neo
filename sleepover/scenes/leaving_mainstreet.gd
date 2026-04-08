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
@onready var move_back = $move_back
@onready var move_backC = $move_back/CollisionShape2D
@onready var benny = $benny/Area2D
@onready var benny_C = $benny/Area2D/CollisionShape2D
@onready var ENTER = $ENTER
@onready var ENTER_C = $ENTER/CollisionShape2D

var talking = false
var talk_benny = false
var enter_vant = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	benny_C.disabled = true
	cutscene("RESET")
	
	fadeAnimation.play("fadein")
	
	p.last_action = "r"
	talking = true
	p.can_interact = false
	
	t._emote("sam", "derp")
	await speak("You", "Simple enough.", "", "", "")
	e()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	p.talking = talking
	
	if pArea.overlaps_area(move_back):
		await cutscene("move_away")
		benny_C.disabled = false
		move_backC.disabled = true
	
	if !talking:
		if pArea.overlaps_area(benny):
			p.can_interact = true
			if Input.is_action_just_pressed("interact"):
				benny_C.disabled = true
				p.can_interact = false
				talking = true
				
				t._emote("benny", "normal")
				await speak("Benny", "Good bye.", "", "", "")
				t._emote("sam", "normal")
				await speak("You", "Later man.", "", "", "")
				e()
				
				talking = false
			
		elif pArea.overlaps_area(ENTER):
			p.can_interact = true
			
			if Input.is_action_just_pressed("interact"):
				
				talking = true
				
				t._emote("sam", "normal")
				p.emote_icon("worry")
				await speak("You", "I can't believe it.", "", "", "")
				t._emote("sam", "smile2")
				await speak("You", "I can't believe I met him. Today of all days.", "", "", "")
				await speak("You", "Thought it would take longer, but I guess things just went my way tonight.", "", "", "")
				e()
				
				
				bikeSFX.play()
				fadeAnimation.play("fade")
				await fadeAnimation.animation_finished
				get_tree().change_scene_to_file("uid://n27dfrxyq3d2")
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

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
