extends Node2D
@onready var animation = $animation
@onready var box = $reply

@onready var selection = $selection
@onready var o1 = $selection/option
@onready var o2 = $selection/option2
@onready var o3 = $selection/option3

@onready var text_animation = $text_animation

signal choice_selected(choice_id)
var choice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	o1.pressed.connect(func(): emit_signal("choice_selected", 1))
	o2.pressed.connect(func(): emit_signal("choice_selected", 2))
	o3.pressed.connect(func(): emit_signal("choice_selected", 3))
	
	animation.play("normal")
	_speak("Jet", "Hello! Haven't met you before.", "Um, hello?", "*Ignore*", "...")
	selection.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _speak(name, message, in_1, in_2, in_3):
	
	$name.text = name
	$mainText.text = message
	
	text_animation.play("type")
	await text_animation.animation_finished
	
	if !(in_1 == "" and in_2 == "" and in_3 == ""):
			
		animation.play("enlarge")
		await animation.animation_finished
		
		o1.display = in_1
		o2.display = in_2
		o3.display = in_3
		
		selection.show()
		choice = await choice_selected 
		
		print("Player picked:", choice)
		
	else:
		return

func wait(seconds):
	await get_tree().create_timer(seconds).timeout
