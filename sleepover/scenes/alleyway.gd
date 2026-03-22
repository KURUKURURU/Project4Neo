extends Node2D
@onready var talkUI = $talking_ui


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await talkUI._speak("Jett", "Hello. Nice to finally meet you.", "What?", "Oh, em, are you a friend of Gordon?", "")
	if talkUI.choice == 1:
		talkUI._emote("Jett", "smile")
		talkUI._speak("You", "What? Who're you?", "", "", "")
	elif talkUI.choice == 2:
		talkUI._emote("Jett", "chuckle")
		talkUI._speak("You", "You know Gordon I assume.", "", "", "")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
