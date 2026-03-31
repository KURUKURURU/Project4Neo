extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade

@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui

#@onready var cutsceneA = $cutsceneA

#AREAS
#@onready var benny = $guardguy/Area2D
#@onready var ENTER = $ENTER

var talking = false

func _ready() -> void:
	fadeAnimation.play("fadein")
