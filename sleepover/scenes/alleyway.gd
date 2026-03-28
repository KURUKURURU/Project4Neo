extends Node2D
@onready var talkUI = $talking_ui


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await talkUI._speak("Jett", "Hello. Nice to finally meet you.", "What?", "Oh, em, are you a friend of Gordon?", "")
	if talkUI.choice == 1:
		await talkUI._emote("Jett", "smile")
		await talkUI._speak("You", "What? Who're you?", "", "", "")
		
		talkUI._emote("Jett", "scared")
		await talkUI._speak("You", "Have you been following me?", "", "", "")
		
	elif talkUI.choice == 2:
		#talkUI._emote("Jett", "chuckle")
		await talkUI._speak("You", "You know Gordon I assume.", "", "", "")
		talkUI._emote("Jett", "smile")
		await talkUI._speak("Jett", "I don't know any Gordon.", "", "", "")
		talkUI._emote("test", "s")
		await talkUI._speak("Jett", "But I do know you.", "*Run away*", "What do you want?", "Stop lying.")
		if talkUI.choice == 3:
			talkUI._emote("Jett", "")
			await talkUI._speak("You", "You're from Gordon, don't lie. I know I owe him but he needs to calm down with the collectors.", "", "", "")
			talkUI._emote("Jett", "chuckle")
			await talkUI._speak("Jett", "How bad are your finances?", "", "", "")
		talkUI._end()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
