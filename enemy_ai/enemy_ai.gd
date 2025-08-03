class_name EnemyAI extends CharacterBody3D

@export var _move_speed : float = 1.0
@export var _kill_distance : float = 1.5

@onready var animation_player: AnimationPlayer = $Stranger/AnimationPlayer

const flop_time = 2
const rise_time = 4

const max_health: float = 3
var health: float = 3

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
	

func get_hit() ->void:
	health -=1
	
	if health == 0:
		animation_player.play("StrangerAnimLibrary/Dies")
		return
		#end game logic
	
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

func _physics_process(delta: float) -> void:
	
	if _killing_player:
		return
	
	if GameManager.player_character == null:
		return
	
	# Update the target position (target may have moved)
	_nav_agent_3d.target_position = GameManager.player_character.global_position
	
	# Get the movement direction from the navigation path
	var move_dir : Vector3 = _nav_agent_3d.get_next_path_position() - global_position
	move_dir = move_dir.normalized()
	velocity = move_dir * _move_speed
	
	# Rotation
	var angle : float = Vector3.FORWARD.angle_to(move_dir)
	var progress : float = angle - rotation.y
	rotate_y(progress * delta)
	
	move_and_slide()

	# Kill the target if within distance
	var distance_to_target : float = (GameManager.player_character.global_position - global_position).length()
	if distance_to_target <= _kill_distance:
		_kill_player()
