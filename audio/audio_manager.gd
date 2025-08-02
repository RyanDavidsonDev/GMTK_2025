extends Node

var _killer_surprise_audio_player : AudioStreamPlayer3D = null
var _killer_default_audio_player : AudioStreamPlayer3D = null
var _killer_chase_audio_player : AudioStreamPlayer3D = null

var _required_out_of_sight_time_for_reset : float = 10.0
var _chase_time_remaining : float = 0.0

func initialize_killer_audio(killer: EnemyAI) -> void:
	
	_killer_surprise_audio_player = $KillerSurprisePlayer
	_killer_default_audio_player = $KillerDefaultPlayer
	_killer_chase_audio_player = $KillerChasePlayer
	
	_killer_default_audio_player.play()
	_killer_chase_audio_player.volume_linear = 0.0
	_killer_chase_audio_player.play()

func _physics_process(delta: float) -> void:
	
	if GameManager.enemy_ai == null:
		return
	
	# Default audio is based on "terror radius", pathing distance from the killer to the player
	var killer_path_distance : float = GameManager.enemy_ai.get_path_distance_from_player()
	_killer_default_audio_player.volume_db = -(killer_path_distance / 2.0)
	
	var can_see_player : bool = GameManager.enemy_ai.can_see_player()
	
	# Killer can see the player
	if can_see_player:
		
		# Currently outside of a chase, begin a chase
		if _chase_time_remaining <= 0.0:
			_killer_surprise_audio_player.play()
		
		_chase_time_remaining = _required_out_of_sight_time_for_reset
	
	_killer_chase_audio_player.volume_linear = max(0.0, _chase_time_remaining) / _required_out_of_sight_time_for_reset
	_chase_time_remaining -= delta
