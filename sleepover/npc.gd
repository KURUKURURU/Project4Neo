extends Node2D
@onready var animation = $animation
@onready var emoteIcon = $emoteIcon
@onready var emoteAnim = $emoteIcon/animation
@onready var japan = $japan

@export var move = ""
@export var last_action := "d"
@export var npc = ""

#@export var emote := "" 
var moving = true
var frank_direct = ""

var talking = false
var cutscene = false

#

func _ready() -> void:
	emoteIcon.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	

	if move == "right" and !talking:
		animation.flip_h = false
		frank_direct = npc + "_" + move
		animation.play(frank_direct)
		
		last_action = "r"
		
	elif move == "left" and !talking:
		animation.flip_h = false
		frank_direct = npc + "_" + move
		animation.play(frank_direct)
		
		last_action = "r"
		
	elif move == "up" and !talking:
		animation.flip_h = false
		frank_direct = npc + "_" + move
		animation.play(frank_direct)
		
		last_action = "u"
		
	elif move == "down" and !talking:
		animation.flip_h = false
		frank_direct = npc + "_" + move
		animation.play(frank_direct)
		
		last_action = "d"
	
	else:
		
		if last_action == "u":
			frank_direct = npc + "_" + last_action
		elif last_action == "d":
			frank_direct = npc + "_" + last_action
		elif last_action == "":
			last_action = "d"
			frank_direct = npc + "_" + last_action
		elif last_action == "r":
			frank_direct = npc + "_" + last_action
		elif last_action == "l":
			frank_direct = npc + "_" + last_action
		
		animation.play(frank_direct)

func emote_icon(emote):
	emoteIcon.show()
	
	var frank = "res://images/emoteicons/" + emote + ".png"
	
	emoteIcon.texture = load(frank)
	emoteAnim.play("popup")
	
	
	await emoteAnim.animation_finished
	emoteIcon.hide()
