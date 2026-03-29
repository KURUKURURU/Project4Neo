extends CharacterBody2D
@onready var animation = $animation
@onready var interactIcon = $interactIcon

@export var speed = 500 
var can_interact = false
var moving = true
#
func _process(delta: float) -> void:
	if can_interact:
		interactIcon.show()
	else:
		interactIcon.hide()

func _physics_process(delta):
# setup direction of movement
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if moving:
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
	
	if Input.is_action_pressed("right") || Input.is_action_pressed("left") or Input.is_action_pressed("up") || Input.is_action_pressed("down") :
		#if animation.animation == "wal":
		animation.play("walk")
	else:
		animation.play("idle")
