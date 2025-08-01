extends Node

@export var killer_track : AudioStreamMP3 = null

var _killer_audio_player : AudioStreamPlayer3D = null

func initialize_killer_track(killer: EnemyAI) -> void:
	
	_killer_audio_player = AudioStreamPlayer3D.new()
	killer.add_child(_killer_audio_player)
	_killer_audio_player.stream = killer_track
	_killer_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	_killer_audio_player.panning_strength = 0.0
	_killer_audio_player.play()

func _physics_process(delta: float) -> void:
	
	var killer_path_distance : float = GameManager.enemy_ai.get_path_distance_from_player()
	killer_path_distance /= 4.0
	_killer_audio_player.volume_db = -(killer_path_distance * killer_path_distance)
