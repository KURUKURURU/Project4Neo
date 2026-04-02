extends CharacterBody2D
@onready var animation = $animation
@onready var interactIcon = $interactIcon
@onready var emoteIcon = $emoteIcon
@onready var emoteAnim = $emoteIcon/animation

@export var speed = 500 
@export var directassist = "" 

var last_action = ""
#@export var emote := "" 
var can_interact = false
var moving = true
var talking = false
var cutscene = false
#

func _ready() -> void:
	emoteIcon.hide()

func _process(delta: float) -> void:
	#if directassist != "":
		#match directassist:
			#"r":
				#animation.flip_h = false
				#animation.play("side")
				#last_action = "r"
			#"l":
				#animation.flip_h = true
				#animation.play("side")
				#last_action = "l"
			#"u":
				#animation.flip_h = false
				#animation.play("up")
				#last_action = "u"
			#"d":
				#animation.flip_h = false
				#animation.play("down")
				#last_action = "d"
		#return
	
	if can_interact:
		interactIcon.show()
	else:
		interactIcon.hide()
		
	if cutscene:
		return
		
	elif Input.is_action_pressed("right") and !talking:
		animation.flip_h = true
		animation.play("side")
		
		last_action = "r"
		
	elif Input.is_action_pressed("left") and !talking:
		animation.flip_h = false
		animation.play("side")
		
		last_action = "r"
		
	elif Input.is_action_pressed("up") and !talking:
		animation.flip_h = false
		animation.play("up")
		
		last_action = "u"
		
	elif Input.is_action_pressed("down") and !talking:
		animation.flip_h = false
		animation.play("down")
		
		last_action = "d"
	
	else:
		
		if last_action == "u":
			animation.play("up_1")
		elif last_action == "d":
			animation.play("down_1")
		elif last_action == "":
			animation.play("down_1")
		elif last_action == "r":
			animation.play("side_1")
		elif last_action == "l":
			animation.play("side_1")
		

func _physics_process(delta):
# setup direction of movement
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if !cutscene and moving:
		if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
			direction.y = 0
		elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
			direction.x = 0
		else:
			direction = Vector2.ZERO
	
			
		direction = direction.normalized()
# setup the actual movement
		velocity = (direction * speed)
		move_and_slide()

func emote_icon(emote):
	emoteIcon.show()
	
	var frank = "res://images/emoteicons/" + emote + ".png"
	
	emoteIcon.texture = load(frank)
	emoteAnim.play("popup")
	
	
	await emoteAnim.animation_finished
	emoteIcon.hide()
	
