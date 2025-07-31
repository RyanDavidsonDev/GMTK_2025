class_name EnemyAI extends CharacterBody3D

@export var _move_speed : float = 1.0
@export var _kill_distance : float = 1.5

var _nav_agent_3d : NavigationAgent3D = null

var _killing_player : bool = false

func _kill_player() -> void:
	
	print("YOUR ASS IS GRASS!")
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
