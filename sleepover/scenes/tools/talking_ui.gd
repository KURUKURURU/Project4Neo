extends Node2D
@onready var animation = $animation
@onready var box = $reply

@onready var selection = $selection
@onready var o1 = $selection/option
@onready var o2 = $selection/option2
@onready var o3 = $selection/option3

@onready var text_animation = $text_animation
@onready var S = $Sprite
@onready var advance = $advance
@onready var ding = $ding

signal choice_selected(choice_id)
var choice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("normal")
	advance.hide()
	self.hide()
	advance.hide() 
	
	o1.activate.connect(func(): emit_signal("choice_selected", 1))
	o2.activate.connect(func(): emit_signal("choice_selected", 2))
	o3.activate.connect(func(): emit_signal("choice_selected", 3))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _speak(name, message, in_1, in_2, in_3):
	self.show()
	
	if animation.get_assigned_animation() == "enlarge":
		$name.text = name
		$mainText.text = ""
		
		animation.play("shrink")
		await animation.animation_finished
		animation.play("normal")
	
	$mainText.visible_ratio = 0
	
	$name.text = name
	$mainText.text = message
	
	var time = message.length() / 35
	
	text_animation.play("type")
	ding.play()
	await text_animation.animation_finished
	
	if !(in_1 == "" and in_2 == "" and in_3 == ""):
			
		animation.play("enlarge")
		await animation.animation_finished
		
		o1.display = in_1
		o2.display = in_2
		o3.display = in_3
		
		selection.show()
		choice = await choice_selected 
		
		print("Player picked... ", choice)
		
	else:
		await wait(time)
		await _advance()
		return

func _emote(name: String, emotion: String): #files are named specifically!!! PLEASE DONT SCREW THIS UP
	S.sprite = name
	S.emote = emotion

func _advance():
	advance.show()
	await advance.pressed 
	
	advance.hide()

func _input(event):
	if advance.visible and event.is_action_pressed("ui_accept"):
		advance.hide()
		advance.emit_signal("pressed")

func _end():
	self.hide()

func wait(seconds):
	await get_tree().create_timer(seconds).timeout
