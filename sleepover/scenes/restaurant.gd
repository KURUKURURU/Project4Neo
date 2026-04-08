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
	await speak("Big Vant", "Sam! Grab a plate, the chef finally made a dish remotely edible.", "No thanks.", "I can't.", "")
	
	if t.choice == 1:
		print("debug")
		t._emote("sam", "normal")
		p.emote_icon("wrong")
		await speak("You", "No thanks. I'm trying to stay on good terms with my stomach right now.", "", "", "")
		await speak("You", "I don't trust what that man serves for a second,", "", "", "")
		await speak("You", "No disrespect to you of course.", "", "", "")
		t._emote("vant", "smile")
		await speak("Big Vant", "Have some faith in the guy.", "", "", "")
	elif t.choice == 2:
		damon.last_action = "d"
		t._emote("sam", "normal")
		await speak("You", "Can't have shellfish. Thanks though.", "", "", "")
		t._emote("vant", "think")
		vant.emote_icon("dots")
		await speak("Big Vant", "A life without shrimp, how disdainful.", "", "", "")
	
	t._emote("vant", "smug")
	await speak("Big Vant", "Daniel, this here is who've I've been talking about.", "", "", "")
	await speak("Big Vant", "I learned of him from an old friend of mine. Both of them had a security gig together, a good pairing.", "", "", "")
	
	await speak("Big Vant", "Quick mind, and very experienced.", "", "", "")
	await speak("Big Vant", "And he's quiet.", "", "", "")
	t._emote("vant", "think")
	await speak("Big Vant", "When it counts.", "", "", "")
	await speak("Big Vant", "...Though he's working for me at present, I'm willing to let you borrow him.", "", "", "")
	t._emote("vant", "smug")
	vant.emote_icon("exclamation")
	await speak("Big Vant", "Oh, Samuel, let me introduce you.", "", "", "")
	speak("Big Vant", "This is Daniel Damon, a-", "", "", "")
	await wait(1.0)
	
	damon.last_action = "u"
	t._emote("damon", "normal")
	await speak("Damon", "I can introduce myself, Vant, thank you.", "", "", "")
	damon.last_action = "d"
	await speak("Damon", "I am Daniel Damon.", "", "", "")
	await speak("Damon", "I am the security officer of your future client.", "", "", "")
	await speak("Damon", "We are in need of a security guard for some of our property.", "", "", "")
	
	t._emote("damon", "smile")
	await speak("Damon", "We need to have adequate security in order to protect our valuable research.", "", "", "")
	await speak("Damon", "We need someone that can get the job done quietly and efficiently. Resorting to [shake]extreme methods [/shake]when neccessary,", "", "", "")
	await speak("Damon", "And can deal with the after effects.", "", "", "")
	t._emote("damon", "sad")
	await speak("Damon", "..", "", "", "")
	t._emote("damon", "direct")
	await speak("Damon", "Say, [shake]what kind of man are you?[/shake]", "Problem-solver.","Jack of all trades.", "Do what it takes.")
	t._emote("sam", "normal")
	if t.choice == 1:
		await speak("You", "I solve problems, and any issue can be taken care of.", "", "", "")
		await speak("You", "I have lines I try not to cross though.", "", "", "")
		await speak("You", "Like, you know, the k-word.", "", "", "")
		damon.emote_icon("dots")
		t._emote("damon", "sad")
		await speak("Damon", "As does everybody, but your cleanliness may pose some issues in my employee skill wishlist.", "", "", "")
		damon.emote_icon("dots")
		await speak("Damon", "Though, I am desperate at the current moment, so your skills and limitations may come along for this position.", "", "", "")
	elif t.choice == 2:
		await speak("You", "I’ve got solid experience, and I’ve been working with Mr. Vant for two years now.", "", "", "")
		await speak("You", "I've done a lot of gigs, but security really just stuck.", "", "", "")
		await speak("You", "I can pick up things quick even without proper training.", "", "", "")
		await speak("You", "Mr. Vant can vouch for me.", "", "", "")
		t._emote("vant","smile")
		await speak("Big Vant", "I can.", "", "", "")
		damon.emote_icon("correct")
		
	elif t.choice == 3:
		await speak("You", "I'll do what the job asks.", "", "", "")
		await speak("You", "I'm persistent and I don't quit halfway.", "", "", "")
		damon.emote_icon("correct")
		t._emote("damon", "normal")
		await speak("Damon", "That isn't very different from what I already know.", "", "", "")
		 
	
	t._emote("damon", "smile")
	await speak("Damon", "I have heard of your many talents from Vant.", "", "", "")
	damon.last_action = "u"
	await speak("Damon", "I find your employee here competent, as his background in security speaks for itself.", "", "", "")
	await speak("Damon", "I don’t mean to rush or bypass any part of the hiring process, but I’m currently in a situation where I don’t have the flexibility to explore second options..", "", "", "")
	damon.last_action = "d"
	await speak("Damon", "You've probably heard of [shake rate=20.0 level=5 connected=1]Brightwell Care[/shake]. We've been on the news several times already.", "", "", "")
	await speak("Damon", "We do groundbreaking research on the care and behavior of [shake rate=20.0 level=5 connected=1]children[/shake].", "", "", "")
	await speak("Damon", "Of course, the children must be protected, including any kind of personal information in our warehouses.", "", "", "")
	await speak("Damon", "...", "", "", "")
	await speak("Damon", "Your job is simple.", "", "", "")
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
