class_name EnemyAI extends CharacterBody3D

@export var _move_speed : float = 1.0
@export var _kill_distance : float = 1.5

var _nav_agent_3d : NavigationAgent3D = null

var _killing_player : bool = false

func can_see_player() -> bool:
	
	var params : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	params.from = global_position
	params.to = GameManager.player_character.global_position
	
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

func _ready() -> void:
	
	_nav_agent_3d = $NavigationAgent3D
	
	GameManager.register_enemy_ai(self)

func _physics_process(delta: float) -> void:
	
	if _killing_player:
		return
	
	if GameManager.player_character == null:
		return
	
	# Update the target position (target may have moved)
	_nav_agent_3d.target_position = GameManager.player_character.global_position
	
	# Get the movement direction from the navigation path
	var move_dir : Vector3 = _nav_agent_3d.get_next_path_position() - global_position
	velocity = move_dir.normalized() * _move_speed
	
	move_and_slide()

	# Kill the target if within distance
	var distance_to_target : float = (GameManager.player_character.global_position - global_position).length()
	if distance_to_target <= _kill_distance:
		_kill_player()
