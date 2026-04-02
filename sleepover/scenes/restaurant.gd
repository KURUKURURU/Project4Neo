extends Node2D

@onready var fadeAnimation = $top/fade/animation
@onready var p = $Player
@onready var pAnim = $Player/animation
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui
@onready var c = $cutscenes

@onready var big_boss = $big_boss
@onready var vant = $Vant

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
		big_boss.monitoring = false
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
	speak("Big Vant", "[wave amp=80.0 freq=5.0 connected=1]AHAHHAAHHAHAHHAHA!![/wave]", "", "", "")
	await wait(1.0)
	await speak("Big Vant", "*clears throat*", "", "", "")
	
	await speak("Big Vant", "Good evening Sam! Grab a plate, the chef finally made something remotely edible.", "No thanks.", "I can't.", "")
	if t.choice == 1:
		print("debug")
		await speak("You", "No thanks. You sure that isn't store bought?", "", "", "")
		await speak("Big Vant", "Have some faith in the guy.", "", "", "")
	elif t.choice == 2:
		await speak("You", "I can't have shellfish, thanks though.", "", "", "")
		vant.emote_icon("dots")
		await speak("Big Vant", "A life without shrimp, how disdainful.", "", "", "")
		
	await speak("Big Vant", "Daniel, this here is who've I've been talking about.", "", "", "")
	await speak("Big Vant", "A good worker, and he's quiet too.", "", "", "")
	await speak("Big Vant", "Well, when it counts.", "", "", "")
	
	vant.emote_icon("exclamation")
	await speak("Big Vant", "Oh, please Samuel, please meet my good friend here.", "", "", "")
	speak("Big Vant", "He's Daniel Damon, a-", "", "", "")
	await wait(1.0)
	await speak("Damon", "I can introduce myself, Vant, thank you.", "", "", "")
	await speak("Damon", "You've probably heard of [shake rate=20.0 level=5 connected=1]Brightwell Industries[/shake]. We've been on the news several times already.", "", "", "")
	await speak("Damon", "We do groundbreaking research on the care and behavior of [shake rate=20.0 level=5 connected=1]children[/shake].", "", "", "")
	await speak("Damon", "We need to have adequate security in order to protect our research.", "", "", "")
	await speak("Damon", "We need someone that can get the job done quietly and efficiently. Resorting to [shake]extreme methods [/shake]when neccessary.", "", "", "")
	await speak("Damon", ".", "", "", "")
	
	await speak("Damon", "Say, what kind of man are you?", "Smart.", "Hard-working.", "Determined.")
	
	
	
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
