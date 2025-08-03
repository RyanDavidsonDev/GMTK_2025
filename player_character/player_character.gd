class_name PlayerCharacter extends CharacterBody3D

const INTERACTION_DISTANCE: float = 2
const LOOK_DISTANCE: float = 50

@export var _move_speed : float = 2.0
@export var _look_sensitivity: float = 1.0
@export_flags_3d_physics var raycast_collison_mask = 0
@onready var gun:Gun = %gun

@onready var camera: Camera3D = $Camera3D
@onready var ui_overlay: Node = $UiOverlay
#@onready var crosshair

@onready var animation_player = $Camera3D/GunHandres/AnimationPlayer
@onready var animation_player_2 = $Camera3D/GunHandres/AnimationPlayer2

@onready var crosshair:TextureRect = ui_overlay.find_child("crosshair")

var _input_move_direction : Vector2 = Vector2.ZERO
var _input_mouse_direction : Vector2 = Vector2.ZERO

var _camera_3d : Camera3D = null

var has_key: bool = false

var was_looking_at_interactable: bool = false
var was_looking_at_enemy: bool = false

var num_times_tried_reload : int = 0

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
	if Input.is_action_pressed("reload"):
		gun.reload()
		
	if _input_move_direction != Vector2.ZERO && gun.is_reloading:
		
		GameManager.hud_controller.show_text_timer("\"I'm not familiar enough with this gun to reload it and keep walking\"")
		gun.interrupt_reload()
		
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
	
	#var mousepos = get_viewport().get_mouse_position()
	var mousepos = crosshair.position
	
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * LOOK_DISTANCE
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = (raycast_collison_mask)
	var result:Dictionary = space_state.intersect_ray(query)
	
	var EnemyIsInSight : bool = false
	
	#if we see something
	if(!result.is_empty()):
		var position: Vector3 = result.position
		var collider: Node3D = result.collider
		
		if collider is EnemyAI:
			GameManager.hud_controller.target_crosshair()
			if GameManager.player_character.gun.loaded_bullet_count >0 :
				if !was_looking_at_enemy:
					#gameman.hudcont.switchcrosshair(fire)
					GameManager.hud_controller.show_text_continual("Press \'E\' or click Left Mouse Button to fire")
			else :
				if !was_looking_at_enemy:
					GameManager.hud_controller.show_text_timer("Press 'R' to reload")
			EnemyIsInSight = true
			was_looking_at_enemy = true
		else: if (position.distance_to(origin) < INTERACTION_DISTANCE):
			if !was_looking_at_interactable:
				GameManager.hud_controller.interact_crosshair()
				GameManager.hud_controller.show_text_continual("Press \'E\' or click Left Mouse Button to interact")
			#hide text on look away?
			if Input.is_action_just_pressed("Interact"):
				GameManager.hud_controller.interact_crosshair()
			#gameman.hudcont.switchcrosshair(fire) also maybe
				collider.interact(self)
			was_looking_at_interactable = true
	else: if was_looking_at_interactable or was_looking_at_enemy:
		was_looking_at_interactable = false
		was_looking_at_enemy = false
		#might still wipe unrelated - consider splitting into separate signals or wipe correspective signals
		GameManager.hud_controller.sig_hide_continual_text.emit()
		GameManager.hud_controller.normal_crosshair()
	
	if Input.is_action_just_pressed("Interact"):
		if EnemyIsInSight:
			print("bang")
			gun.try_fire()
			
func play_animation(animation: String):
	animation_player.play(animation)
	
func play_animation_2(animation: String):
	animation_player_2.play(animation)

			
