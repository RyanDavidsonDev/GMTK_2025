class_name EnemyAI extends CharacterBody3D

@export var _move_speed : float = 1.0
@export var _kill_distance : float = 1.5

@onready var animation_player: AnimationPlayer = $Stranger/AnimationPlayer

@export var _interactable : Interactable = null

const flop_time = 2
const rise_time = 4

@export var cycle_duration: float = 2.035 
@export var min_speed: float = 0.6
@export var max_speed: float = 1.0
@export var step_phase_offset: float = 0.0 #foot offset

var step_phase: float = 0.0

const max_health: float = 3
var health: float = 3

var _nav_agent_3d : NavigationAgent3D = null

@export var region : NavigationRegion3D
var geo_data:  NavigationMeshSourceGeometryData3D


var _killing_player : bool = false

func can_see_player() -> bool:
	
	var params : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	params.from = global_position
	if(GameManager.player_character == null):
		return false
	params.to = GameManager.player_character.global_position
	
	if get_world_3d() == null:
		return false
		
	var hit : Dictionary = get_world_3d().direct_space_state.intersect_ray(params)
	
	return hit.collider is PlayerCharacter

func get_path_distance_from_player() -> float:
	
	var path : PackedVector3Array = _nav_agent_3d.get_current_navigation_path()
	var total_distance : float = 0.0
	for i: int in range(path.size() - 1):
		total_distance += path[i].distance_to(path[i + 1])
	return total_distance
	
	return _nav_agent_3d.distance_to_target()

func _kill_player() -> void:
	
	#GameManager.hud_controller.show_text_timer("you died")
	
	_killing_player = true
	
	GameManager.player_character_killed()
	

func get_hit() ->void:
	health -=1
	
	if health == 0:
		animation_player.play("StrangerAnimLibrary/Dies")
		GameManager.enemy_killed()
		return
	
	animation_player.play("StrangerAnimLibrary/Flop Animation")
	var p_move_speed = _move_speed
	_move_speed = 0
	await get_tree().create_timer(flop_time).timeout
	
	animation_player.play("StrangerAnimLibrary/Rise Animation")
	await get_tree().create_timer(rise_time).timeout
	
	_move_speed = p_move_speed
	
	animation_player.play("StrangerAnimLibrary/Walk Animation")
	

func _ready() -> void:
	
	_nav_agent_3d = $NavigationAgent3D
	
	GameManager.register_enemy_ai(self)
	
	_interactable.hovered.connect(_on_interactable_hovered)
	_interactable.unhovered.connect(_on_interactable_unhovered)
	_interactable.selected.connect(_on_interactable_selected)
	
	geo_data = NavigationMeshSourceGeometryData3D.new()
	
	

func sigreceive():
	print("hi")

func rebake_nav_mesh() -> void:
	print("rebaking mesh")
	NavigationServer3D.parse_source_geometry_data(region.navigation_mesh, geo_data, self)
	#NavigationMeshGenerator.bake(region.navigation_mesh, )
	return

func _physics_process(delta: float) -> void:
	if _killing_player or health == 0 or GameManager.player_character == null:
		return
	
	_nav_agent_3d.target_position = GameManager.player_character.global_position
	
	#direction prob
	var move_dir: Vector3 = (_nav_agent_3d.get_next_path_position() - global_position)
	if move_dir.length() > 0.01:
		move_dir = move_dir.normalized()
	else:
		move_dir = Vector3.ZERO
	
	#TIME FOR FOOT MATH
	step_phase += delta
	if step_phase > cycle_duration:
		step_phase -= cycle_duration
	
	var theta = ((step_phase + step_phase_offset) / cycle_duration) * PI * 2
	var stagger_multiplier = min_speed + (max_speed - min_speed) * max(0.0, -sin(theta))

	velocity = move_dir * _move_speed * stagger_multiplier
	
	#rotation i think
	#if move_dir != Vector3.ZERO:
	var angle : float = Vector3.FORWARD.angle_to(move_dir)
	var progress : float = angle - rotation.y
	rotate_y(progress * delta)
	
	move_and_slide()
	
	if (GameManager.player_character.global_position - global_position).length() <= _kill_distance:
		_kill_player()

func _on_interactable_hovered() -> void:
	if GameManager.player_character.gun.loaded_bullet_count > 0:
		GameManager.hud_controller.target_crosshair()

func _on_interactable_unhovered() -> void:
	GameManager.hud_controller.normal_crosshair()

func _on_interactable_selected() -> void:
	if GameManager.player_character.gun.loaded_bullet_count > 0:
		GameManager.player_character.gun.fire()
		get_hit()
		GameManager.hud_controller.show_health_bar()
