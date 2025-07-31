class_name PlayerCharacter extends CharacterBody3D

@export var _move_speed : float = 2.0

var _input_move_direction : Vector2 = Vector2.ZERO
var _input_mouse_direction : Vector2 = Vector2.ZERO

var _camera_3d : Camera3D = null

func _ready() -> void:
	
	_camera_3d = $Camera3D

	GameManager.register_player_character(self)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_input_mouse_direction = event.relative

func _process(delta: float) -> void:

	# Process movement input
	
	_input_move_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		_input_move_direction.y += 1.0
	if Input.is_action_pressed("move_backward"):
		_input_move_direction.y -= 1.0
	if Input.is_action_pressed("move_right"):
		_input_move_direction.x += 1.0
	if Input.is_action_pressed("move_left"):
		_input_move_direction.x -= 1.0
		
	_input_move_direction = _input_move_direction.normalized()

func _physics_process(delta: float) -> void:
	
	# Update character rotation
	rotation_degrees.y -= _input_mouse_direction.x
	
	# Update camera rotation
	_camera_3d.rotation_degrees.x -= _input_mouse_direction.y
	_camera_3d.rotation_degrees.x = clampf(_camera_3d.rotation_degrees.x, -90.0, 90.0)
	
	_input_mouse_direction = Vector2.ZERO
	
	# Handle movement
	
	velocity = (transform.basis.z * -_input_move_direction.y) + (transform.basis.x * _input_move_direction.x)
	velocity *= _move_speed
	
	move_and_slide()
