extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()



var _dragging: bool = false

func _process(delta: float) -> void:
	if _dragging:
		var current_position: Vector2 = global_position
		var mouse_position: Vector2 = get_global_mouse_position()
		
		var distance: float = current_position.distance_to(mouse_position)
		var direction: Vector2 = current_position.direction_to(mouse_position)
		
		var speed: float = distance / delta
		
		velocity = direction * speed
		move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and _dragging and not event.pressed:
		_dragging = false

func _on_draggable_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_dragging = event.pressed
