extends Node2D
@onready var fadeAnimation = $top/fade/animation
@onready var fadeColor = $top/fade

@onready var p = $Player
@onready var pArea = $Player/Area2D
@onready var t = $top/talking_ui

@onready var cutsceneA = $cutsceneA

#AREAS
@onready var benny = $guardguy/Area2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cutscene("RESET")
	fadeAnimation.play("fadein")
	
	await speak("You", "I forgot to lock my bike.", "", "", "")
	t._end()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if benny.overlaps_area(pArea):
		if Input.is_action_just_pressed("interact"):
			print("debug")
			await speak("Benny", "Evenin' Sam.", "", "", "")
			await speak("Benny", "You're early as usual. ", "", "", "")
			await speak("Benny", "Off to get another job, hm?", "Yup.", "", "")
			
			await cutscene("move_away")
			
			
			await speak("Benny", "Later.", "", "", "")

#func _interactArea(enteredArea, ):

func speak(n, m, c1, c2, c3):
	p.moving = false
	await t._speak(n, m, c1, c2, c3)
	p.moving = true

func e():
	t._end()

#func _interact(iconPath, randomArea, playerArea, fun):
	#if randomArea.overlaps_area(playerArea):
		#if Input.is_action_just_pressed("interact"):
			
func cutscene(animation):
	cutsceneA.play(animation)
	await cutsceneA.animation_finished
	

func GuardGuyInteract(area: Area2D) -> void:
	if area.overlaps_area(pArea) and p.can_interact:
		p.can_interact = true
		if Input.is_action_just_pressed("interact"):
			p.can_interact = false
			print("debug")
			await speak("Benny", "Evenin' Sam.", "", "", "")
			await speak("Benny", "You're early as usual. ", "", "", "")
			await speak("Benny", "Off to get another job, hm?", "Yup.", "", "")
			
			await cutscene("move_away")
			
			
			await speak("Benny", "Later.", "", "", "")
			e()
			
		
