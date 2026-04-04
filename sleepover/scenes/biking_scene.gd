extends Node2D
@onready var w = $wind
@onready var s1 = $sfx
@onready var s2 = $sfx2
@onready var s3 = $sfx3
@onready var animation = $animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	s1.play()
	await wait(5)
	
	s2.play()
	await s2.finished
	s3.play()
	await s3.finished
	
	w.stop()
	s1.stop()
	s2.stop()
	#s3.stop()
	
	animation.play("fade")
	await animation.animation_finished
	self.hide()
	
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func wait(seconds):
	if not is_inside_tree():
		return
	await get_tree().create_timer(seconds).timeout
