extends Node2D

@onready var fadeAnimation = $top/fade/animation
@onready var p = $Player
@onready var pAnim = $Player/animation
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui
@onready var c = $cutscenes

@onready var big_boss = $big_boss

var talking = false
var cutscene = false

func _ready() -> void:
	p.last_action = "l"
	fadeAnimation.play("fadein")

func _process(_delta: float) -> void:
	
	p.cutscene = cutscene
	
	#if talking:
		#return
	
	# check loud fan
	if pArea.overlaps_area(big_boss):
		await walkin_cutscene()
		#print("debug")
		
	
	else:
		p.can_interact = false


# --- interactions ---

func walkin_cutscene():
	cutscene = true
	talking = true
	p.can_interact = false
	
	#p.last_action = "up"
	
	pAnim.play("up")
	c.play("walk_in")
	
	await c.animation_finished
	pAnim.play("up_1")
	
	await speak("Big Vant", "So I said, 'What kind of man doesn't pay his debt?'", "", "", "")
	await speak("Big Vant", "A dead man.", "", "", "")
	
	t.textbox_emote()
	speak("Big Vant", "AHAHHAAHHAHAHHAHA!!", "", "", "")
	await wait(1.0)
	await speak("Big Vant", "*clears throat*", "", "", "")
	
	#cutscene = false
	
	


# --- dialogue helpers ---

#func _knife():
	#talking = true
	#p.can_interact = false
	#
	#p.emote_icon("worry")
	#t._emote("", "")
	#await speak("You", "Pointy. Don't touch.", "", "", "")
	#
	#end_dialogue()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func speak(n, m, c1, c2, c3):
	p.moving = false
	await t._speak(n, m, c1, c2, c3)
	p.moving = true


func end_dialogue():
	t._end()
	talking = false
	p.can_interact = true
