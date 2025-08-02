extends Node

@export var _killer_default_track : AudioStreamMP3 = null
@export var _killer_chase_track : AudioStreamMP3 = null

var _killer_default_audio_player : AudioStreamPlayer3D = null
var _killer_chase_audio_player : AudioStreamPlayer3D = null

func initialize_killer_audio(killer: EnemyAI) -> void:
	
	# Setup default audio
	_killer_default_audio_player = AudioStreamPlayer3D.new()
	killer.add_child(_killer_default_audio_player)
	_killer_default_audio_player.stream = _killer_default_track
	_killer_default_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	_killer_default_audio_player.panning_strength = 0.0
	_killer_default_audio_player.play()
	
	# Setup chase audio
	_killer_chase_audio_player = AudioStreamPlayer3D.new()
	killer.add_child(_killer_chase_audio_player)
	_killer_chase_audio_player.stream = _killer_chase_track
	_killer_chase_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	_killer_chase_audio_player.panning_strength = 0.0

func _physics_process(delta: float) -> void:
	
	if GameManager.enemy_ai == null:
		return
	
	# Default audio is based on "terror radius", pathing distance from the killer to the player
	var killer_path_distance : float = GameManager.enemy_ai.get_path_distance_from_player()
	killer_path_distance /= 4.0
	_killer_default_audio_player.volume_db = -(killer_path_distance * killer_path_distance)
	
	var can_see_player : bool = GameManager.enemy_ai.can_see_player()
	print(can_see_player)
