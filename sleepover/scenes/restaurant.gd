extends Node2D

@onready var fadeAnimation = $top/fade/animation
@onready var p = $Player
@onready var pAnim = $Player/animation
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui
@onready var c = $cutscenes

@onready var big_boss = $big_boss
@onready var vant = $Vant
@onready var damon = $Damon

var talking = false
var cutscene = false
var played = false

func _ready() -> void:
	p.last_action = "l"
	fadeAnimation.play("fadein")

func _process(_delta: float) -> void:
	
	p.cutscene = cutscene
	#if talking:
		#return
	if cutscene:
		return
	# check loud fan
	if pArea.overlaps_area(big_boss):
		#get_tree().change_scene_to_file("res://scenes/leaving_mainstreet.tscn")
		big_boss.monitoring = false
		if played:
			return
		played = true
		await walkin_cutscene()
		print("Still in tree:", is_inside_tree())
		print("ABOUT TO CHANGE SCENE")
		print("Inside tree:", is_inside_tree())
		print("Tree:", get_tree())
		get_tree().change_scene_to_file("res://scenes/leaving_mainstreet.tscn")
		#print("debug")
		

# --- interactions ---

func walkin_cutscene():
	damon.last_action = "u"
	cutscene = true
	talking = true
	p.can_interact = false
	
	#p.last_action = "up"
	
	pAnim.play("up")
	c.play("walk_in")
	
	await c.animation_finished
	pAnim.play("up_1")
	
	t._emote("vant", "plain")
	await speak("Big Vant", "So I said, 'What kind of man doesn't pay his debt?'", "", "", "")
	t._emote("vant", "smug")
	await speak("Big Vant", "A dead man.", "", "", "")
	
	t.textbox_emote()
	t._emote("vant", "smile")
	speak("Big Vant", "[wave amp=80.0 freq=5.0 connected=1]AHAHHAAHHAHAHHAHA!![/wave]", "", "", "")
	await wait(1.0)
	t._emote("vant", "think")
	await speak("Big Vant", "*clears throat*", "", "", "")
	t._emote("vant", "smug")
	await speak("Big Vant", "Sam! Grab a plate, the chef finally made something remotely edible.", "No thanks.", "I can't.", "")
	
	if t.choice == 1:
		print("debug")
		t._emote("sam", "normal")
		await speak("You", "No thanks. You sure that ain't store bought?", "", "", "")
		t._emote("vant", "smile")
		await speak("Big Vant", "Have some faith in the guy.", "", "", "")
	elif t.choice == 2:
		damon.last_action = "d"
		t._emote("sam", "normal")
		await speak("You", "I can't have shellfish, thanks though.", "", "", "")
		t._emote("vant", "think")
		vant.emote_icon("dots")
		await speak("Big Vant", "A life without shrimp, how disdainful.", "", "", "")
	
	t._emote("vant", "smug")
	await speak("Big Vant", "Daniel, this here is who've I've been talking about.", "", "", "")
	await speak("Big Vant", "A good worker, and he's quiet too.", "", "", "")
	t._emote("vant", "think")
	await speak("Big Vant", "Well, when it counts.", "", "", "")
	t._emote("vant", "smug")
	vant.emote_icon("exclamation")
	await speak("Big Vant", "Oh, please Samuel, please meet my good friend here.", "", "", "")
	speak("Big Vant", "He's Daniel Damon, a-", "", "", "")
	await wait(1.0)
	
	damon.last_action = "u"
	t._emote("damon", "normal")
	await speak("Damon", "I can introduce myself, Vant, thank you.", "", "", "")
	damon.last_action = "d"
	await speak("Damon", "I am Daniel Damon.", "", "", "")
	await speak("Damon", "I am the security officer of your future client.", "", "", "")
	await speak("Damon", "I am very particular on the kind of person they want for this job.", "", "", "")
	
	t._emote("damon", "smile")
	await speak("Damon", "We need to have adequate security in order to protect our research.", "", "", "")
	await speak("Damon", "We need someone that can get the job done quietly and efficiently. Resorting to [shake]extreme methods [/shake]when neccessary.", "", "", "")
	t._emote("damon", "sad")
	await speak("Damon", "..", "", "", "")
	t._emote("damon", "direct")
	await speak("Damon", "Say, [shake]what kind of man are you?[/shake]", "Problem-solver.","Jack of all trades.", "Do what it takes.")
	t._emote("sam", "normal")
	if t.choice == 1:
		await speak("You", "I'm a problem-solver. I can take care of [pulse]any[/pulse] issue.", "", "", "")
		t._emote("damon", "sad")
		await speak("Damon", "Excellent.", "", "", "")
	elif t.choice == 2:
		await speak("You", "I'm skilled in many fields, like art, construction, and defense.", "", "", "")
		t._emote("damon", "sad")
		await speak("Damon", "Art?", "", "", "")
		t._emote("sam", "normal")
		await speak("You", "Abstract art.", "", "", "")
		t._emote("damon", "normal")
		damon.emote_icon("dots")
		speak("Damon", "Well...", "", "", "")
		await wait(1.4)
		
	elif t.choice == 3:
		await speak("You", "I'll do what it takes for what I'm given.", "", "", "")
		await speak("You", "I'm persistent.", "", "", "")
		damon.emote_icon("correct")
		t._emote("damon", "normal")
		await speak("Damon", "That isn't very different from what I already know.", "", "", "")
		 
	
	t._emote("damon", "smile")
	await speak("Damon", "I have heard of your many talents from Vant.", "", "", "")
	damon.last_action = "u"
	await speak("Damon", "I find your employee here competent. Especially with his background in security.", "", "", "")
	damon.last_action = "d"
	await speak("Damon", "You've probably heard of [shake rate=20.0 level=5 connected=1]Brightwell Care[/shake]. We've been on the news several times already.", "", "", "")
	await speak("Damon", "We do groundbreaking research on the care and behavior of [shake rate=20.0 level=5 connected=1]children[/shake].", "", "", "")
	await speak("Damon", "Of course, the children must be protected, including any private information in our warehouses.", "", "", "")
	await speak("Damon", "You're job is simple.", "", "", "")
	fadeAnimation.play("fade")
	
	await fadeAnimation.animation_finished
	await wait(1.0)
	return
	
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

func e():
	t._end()
	talking = false

func wait(seconds):
	if not is_inside_tree():
		return
	await get_tree().create_timer(seconds).timeout

func speak(n, m, c1, c2, c3):
	p.moving = false
	await t._speak(n, m, c1, c2, c3)
	p.moving = true
