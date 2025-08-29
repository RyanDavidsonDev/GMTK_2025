class_name PlayerCharacter extends CharacterBody3D

@export var _move_speed : float = 2.0
@export var _look_sensitivity: float = 10.0

@export var _interaction_shape_cast : ShapeCast3D = null
@export var _interaction_shape_cast_pivot_point : Node3D = null

@onready var gun:Gun = %gun

@onready var camera: Camera3D = $Camera3D
@onready var ui_overlay: Node = $UiOverlay
#@onready var crosshair
@onready var revolver_reloading: Node3D = $Camera3D/RevolverReloading

@onready var animation_player:AnimationPlayer = $Camera3D/RevolverReloading/AnimationPlayer

@onready var crosshair:TextureRect = ui_overlay.find_child("crosshair")

var _input_move_direction : Vector2 = Vector2.ZERO
var _input_mouse_direction : Vector2 = Vector2.ZERO

var _camera_3d : Camera3D = null

var has_key: bool = false

var num_times_tried_reload : int = 0

var _hovered_interactable : Interactable = null

func _ready() -> void:
	
	_camera_3d = $Camera3D
	
	GameManager.register_player_character(self)
	
	# Ensure interaction cast comes from the screen's center
	var screen_center_world = camera.project_ray_origin(get_viewport().size / 2.0)
	_interaction_shape_cast_pivot_point.position.y = screen_center_world.y - global_position.y
	
	# Ensure interaction cast ignores the player
	_interaction_shape_cast.add_exception(self)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_input_mouse_direction += event.relative * _look_sensitivity * 0.01

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
	if Input.is_action_just_pressed("Interact") && _hovered_interactable != null:
		GameManager.hud_controller.hide_text()
		_hovered_interactable.select()
		
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
	
	# Handle hovering interactables
	var interactable : Interactable = _get_closest_interactable()
	if interactable != null:
		if _hovered_interactable == null:
			_hovered_interactable = interactable
			if interactable.isEnemy:
				if GameManager.player_character.gun.loaded_bullet_count >0:
					GameManager.hud_controller.show_text_continual("Press \'E\' or click Left Mouse Button to fire")
				else:
					if GameManager.player_character.gun.bullet_count >0:
						GameManager.hud_controller.show_text_continual("Press \'R\' or click Right Mouse Button to reload")
					else:
						GameManager.hud_controller.show_text_continual("I need ammo")
						
			else:
				GameManager.hud_controller.show_text_continual("Press \'E\' or click Left Mouse Button to interact")
				
			interactable.hover()
		elif _hovered_interactable != interactable:
			
			_hovered_interactable.unhover()
			_hovered_interactable = interactable
			interactable.hover()
	elif _hovered_interactable != null:
		GameManager.hud_controller.hide_text()
		_hovered_interactable.unhover()
		_hovered_interactable = null
	
	# Handle movement
	velocity = (transform.basis.z * -_input_move_direction.y) + (transform.basis.x * _input_move_direction.x)
	velocity *= _move_speed
	move_and_slide()
	
	
func rotate_hands():
	var tween = get_tree().create_tween().set_trans(Tween.TransitionType.TRANS_BOUNCE).set_parallel(false)
	
	revolver_reloading.rotation
	stop_animations()
	var initPos = revolver_reloading.rotation_degrees
	
	var firstDuration: float = 1
	print("rotating")
	
	var finalVar :Vector3 = revolver_reloading.rotation_degrees + Vector3(-60, 0, 0)
	var finalVar2 :Vector3 = revolver_reloading.rotation_degrees + Vector3(60, 0, 0)
	var tweener : PropertyTweener = tween.tween_property(revolver_reloading, "rotation_degrees", finalVar, firstDuration )
	#await get_tree().create_timer(firstDuration).timeout
	print("resetting")
	tween.tween_property(revolver_reloading, "rotation_degrees", initPos, 3 )
	

func play_animation(animation: String):
	#return
	animation_player.play(animation)

func stop_animations():
	#return
	animation_player.stop()
	
func _get_closest_interactable() -> Interactable:
	
	# Update interaction cast rotation
	_interaction_shape_cast_pivot_point.rotation_degrees.x = _camera_3d.rotation_degrees.x
	
	if not _interaction_shape_cast.is_colliding():
		return null
	
	var closest_dist : float = (_interaction_shape_cast.get_collision_point(0) - global_position).length_squared()
	var closest : Node3D = _interaction_shape_cast.get_collider(0)
	for i : int in range(1, _interaction_shape_cast.get_collision_count()):
		var new_dist : float = (_interaction_shape_cast.get_collision_point(i) - global_position).length_squared()
		if new_dist < closest_dist:
			closest_dist = new_dist
			closest = _interaction_shape_cast.get_collider(i)
	
	if closest is Interactable:
		if closest_dist <= closest.selectable_distance:
			return closest
			
	return null
