class_name EnemyAI extends CharacterBody3D

@export var target_node : Node3D = null
@export var move_speed : float = 1.0

var _nav_agent_3d : NavigationAgent3D = null

func _ready() -> void:
	_nav_agent_3d = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	
	_nav_agent_3d.target_position = target_node.global_position
	
	var move_dir : Vector3 = _nav_agent_3d.get_next_path_position() - global_position
	
	velocity = move_dir.normalized() * move_speed
	
	move_and_slide()
