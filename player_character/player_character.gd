class_name PlayerCharacter extends CharacterBody3D

const INTERACTION_DISTANCE: float = 5

@export var _move_speed : float = 2.0
@export var _look_sensitivity: float = 1.0
@export_flags_3d_physics var raycast_collison_mask = 0

@onready var camera: Camera3D = $Camera3D

var _input_move_direction : Vector2 = Vector2.ZERO
var _input_mouse_direction : Vector2 = Vector2.ZERO

var _camera_3d : Camera3D = null

func _ready() -> void:
	
	_camera_3d = $Camera3D

	GameManager.register_player_character(self)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_input_mouse_direction = event.relative * _look_sensitivity

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
	
	
	#raycast 
	var space_state = get_world_3d().direct_space_state
	#camera.get_window().wid
	var mousepos = get_viewport().get_mouse_position()
	
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * INTERACTION_DISTANCE
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = (raycast_collison_mask)
	var result:Dictionary = space_state.intersect_ray(query)
	
	
	
	if(!result.is_empty()):
		print("found something at")
		
		var collider:Node3D = result.collider
		if Input.is_action_just_pressed("Interact"):
			collider.interact(self)
