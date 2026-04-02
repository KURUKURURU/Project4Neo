extends Node2D

@onready var fadeAnimation = $top/fade/animation
@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui

@onready var loudfan = $loud
@onready var bar = $enter_bar
@onready var knife = $knife

var talking = false

func _ready() -> void:
	fadeAnimation.play("fadein")

func _process(_delta: float) -> void:
	if talking:
		return
	
	# check loud fan
	if pArea.overlaps_area(loudfan):
		p.can_interact = true
		if Input.is_action_just_pressed("interact"):
			await loud_fan_dialogue()
	
	# check bar
	elif pArea.overlaps_area(bar):
		p.can_interact = true
		if Input.is_action_just_pressed("interact"):
			await enter_bar_scene()
			
	elif pArea.overlaps_area(knife):
		p.can_interact = true
		if Input.is_action_just_pressed("interact"):
			await _knife()
	
	else:
		p.can_interact = false


# --- interactions ---

func loud_fan_dialogue():
	talking = true
	p.can_interact = false
	
	t._emote("", "")
	await speak("You", "This is pretty loud.", "", "", "")
	await speak("You", "If I compare other's opinions of me, I think I may have competition.", "", "", "")
	
	end_dialogue()

func _knife():
	talking = true
	p.can_interact = false
	
	t._emote("", "")
	await speak("You", "Pointy. Don't touch.", "", "", "")
	
	end_dialogue()



func enter_bar_scene():
	p.can_interact = false
	fadeAnimation.play("fade")
	await fadeAnimation.animation_finished
	get_tree().change_scene_to_file("res://scenes/kitchen.tscn")


# --- dialogue helpers ---

func speak(n, m, c1, c2, c3):
	p.moving = false
	await t._speak(n, m, c1, c2, c3)
	p.moving = true


func end_dialogue():
	t._end()
	talking = false
	p.can_interact = true
