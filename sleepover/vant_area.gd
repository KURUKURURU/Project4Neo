extends Node2D

@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade
@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui

var talking = false
var enter_bar = false
var already_talked = false

func _ready() -> void:
	fadeAnimation.play("fadein")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and !talking:
		if enter_bar:
			talking = true
			p.can_interact = false
			t._emote("", "")
			await speak("", "", "", "", "")
			
			e()
			talking = false

func speak(n, m, c1, c2, c3):
	p.moving = false
	await t._speak(n, m, c1, c2, c3)
	p.moving = true
func e():
	t._end()
	talking = false
	p.can_interact = true
	
func _enter_bar(area: Area2D) -> void:
	if area == pArea:
		p.can_interact = true
		enter_bar = true
		
func exit(area):
	if area == pArea:
		p.can_interact = false
		enter_bar = false
