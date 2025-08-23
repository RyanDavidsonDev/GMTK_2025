extends Node

var _killer_surprise_audio_player : AudioStreamPlayer3D = null
var _killer_default_audio_player : AudioStreamPlayer3D = null
var _killer_chase_audio_player : AudioStreamPlayer3D = null
var _menu_audio_player : AudioStreamPlayer2D = null

@export var _lose_stream : AudioStream
@export var _win_stream : AudioStream = null
@export var _pause_stream : AudioStream = null
@export var _main_menu_stream: AudioStream = null 

var _required_out_of_sight_time_for_reset : float = 10.0
var _chase_time_remaining : float = 0.0

func initialize_killer_audio(killer: EnemyAI) -> void:
	
	_menu_audio_player.stop()
	
	_chase_time_remaining = 0.0
	_killer_default_audio_player.seek(0)
	_killer_default_audio_player.play()
	_killer_default_audio_player.stream_paused = true
	_killer_chase_audio_player.volume_linear = 0.0
	_killer_chase_audio_player.seek(0)
	_killer_chase_audio_player.play()
	_killer_chase_audio_player.stream_paused = true
	
	play_killer_audio()

func play_killer_audio() -> void:
	
	_menu_audio_player.stop()
	
	_killer_default_audio_player.stream_paused = false
	_killer_chase_audio_player.stream_paused = false

func play_main_menu_audio() -> void:
	_play_menu_audio(_main_menu_stream)

func play_pause_audio() -> void:
	_play_menu_audio(_pause_stream)
	
func play_win_audio() -> void:
	_play_menu_audio(_win_stream)
	
func play_lose_audio() -> void:
	_play_menu_audio(_lose_stream)
	
func cut_audio() -> void:
	
	_menu_audio_player.stop()
	
	_killer_default_audio_player.stream_paused = true
	_killer_chase_audio_player.stream_paused = true
	
func _play_menu_audio(stream:AudioStream) -> void:
	
	_killer_default_audio_player.stream_paused = true
	_killer_chase_audio_player.stream_paused = true
	
	_menu_audio_player.stream = stream
	_menu_audio_player.seek(0)
	_menu_audio_player.play()

func _ready() -> void:
	
	_killer_surprise_audio_player = $KillerSurprisePlayer
	_killer_default_audio_player = $KillerDefaultPlayer
	_killer_chase_audio_player = $KillerChasePlayer
	_menu_audio_player = $MenuPlayer
	
	play_main_menu_audio()

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
			_killer_surprise_audio_player.seek(0)
			_killer_surprise_audio_player.play()
		
		_chase_time_remaining = _required_out_of_sight_time_for_reset
	
	_killer_chase_audio_player.volume_linear = max(0.0, _chase_time_remaining) / _required_out_of_sight_time_for_reset
	_chase_time_remaining -= delta
