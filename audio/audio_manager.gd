extends Node

var _menu_audio_player : AudioStreamPlayer2D = null

var _killer_surprise_audio_player : AudioStreamPlayer3D = null
var _killer_default_audio_player : AudioStreamPlayer3D = null
var _killer_chase_audio_player : AudioStreamPlayer3D = null

@export var loseGameMusic : AudioStream
@export var winGameMusic : AudioStream = null
@export var pauseGameMusic : AudioStream = null
@export var MainmenuMusic: AudioStream = null 

var _required_out_of_sight_time_for_reset : float = 10.0
var _chase_time_remaining : float = 0.0

func initialize_killer_audio(killer: EnemyAI) -> void:
	
	_menu_audio_player.stop()
	
	_chase_time_remaining = 0.0
	_killer_default_audio_player.seek(0)
	_killer_default_audio_player.play()
	_killer_chase_audio_player.volume_linear = 0.0
	_killer_chase_audio_player.seek(0)
	_killer_chase_audio_player.play()

func play_menu_music() -> void:
	
	_killer_surprise_audio_player.stop()
	_killer_default_audio_player.stop()
	_killer_chase_audio_player.stop()
	
	_menu_audio_player.stream = MainmenuMusic
	
	_menu_audio_player.seek(0)
	_menu_audio_player.play()
	

func start_menu_audio(Audio: AudioStream, just_pause: bool = false):
	print("starting")
	if(just_pause):
		_killer_default_audio_player.stop()
		_killer_chase_audio_player.stop()
	else:
		_killer_default_audio_player.stop()
		_killer_chase_audio_player.stop()
	
	_killer_default_audio_player.seek(0)
	_menu_audio_player.stream = Audio
	_menu_audio_player.play()
	

func start_killer_audio():
	_menu_audio_player.stop()
	
	_killer_default_audio_player.play()
	_killer_chase_audio_player.play()
	
	

func _ready() -> void:
	
	_menu_audio_player = $MenuPlayer
	
	_killer_surprise_audio_player = $KillerSurprisePlayer
	_killer_default_audio_player = $KillerDefaultPlayer
	_killer_chase_audio_player = $KillerChasePlayer
	
	play_menu_music()

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
