class_name PlayerCharacter extends CharacterBody3D

@export var _move_speed : float = 2.0

var _input_direction : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:

	# Process movement input
	
	_input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		_input_direction.y += 1.0
	if Input.is_action_pressed("move_backward"):
		_input_direction.y -= 1.0
	if Input.is_action_pressed("move_right"):
		_input_direction.x += 1.0
	if Input.is_action_pressed("move_left"):
		_input_direction.x -= 1.0
		
	_input_direction = _input_direction.normalized()

func _physics_process(delta: float) -> void:
	
	velocity = (transform.basis.z * -_input_direction.y) + (transform.basis.x * _input_direction.x)
	velocity *= _move_speed
	
	move_and_slide()
