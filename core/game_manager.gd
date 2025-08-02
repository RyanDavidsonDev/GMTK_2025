extends Node

@export var game_scene : PackedScene = null
@export var menu_scene : PackedScene = null

var player_character : PlayerCharacter = null
var enemy_ai : EnemyAI = null
var hud_controller : HUDController = null

func register_player_character(instance: PlayerCharacter) -> void:
	
	if player_character != null:
		printerr("Reference to player character is already set. Ensure cleanup of previous character before registering a new one.")
		return
	
	player_character = instance
	
func register_enemy_ai(instance: EnemyAI) -> void:
	
	if enemy_ai != null:
		printerr("Reference to enemy ai is already set. Ensure cleanup of previous enemy before registering a new one.")
		return
	
	enemy_ai = instance
	AudioManager.initialize_killer_audio(enemy_ai)

func register_hud(instance: HUDController):
	if hud_controller != null:
		printerr("Reference to hud controller is already set. Ensure cleanup of previous hud controller before registering a new one.")
		return
	
	hud_controller = instance

func player_character_killed() -> void:
	
	_cleanup_game()
	_load_game()
	
func load_menu() -> void:
	
	_cleanup_game()
	get_tree().change_scene_to_packed(menu_scene)
	
func _cleanup_game() -> void:
	
	print(get_tree().current_scene)
	
	if get_tree().current_scene.scene_file_path != game_scene.resource_path:
		printerr("Attempting to clean up game but game is not loaded.")
		return
		
	get_tree().unload_current_scene()
	player_character = null
	enemy_ai = null
	
func _load_game() -> void:
	
	if get_tree().current_scene != null && get_tree().current_scene.scene_file_path == game_scene.resource_path:
		printerr("Attempting to load game but game is already loaded.")
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	get_tree().change_scene_to_packed(game_scene)
	
func _ready() -> void:
	
	
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#_load_game.call_deferred()

# Returns true if game becomes paused and false if it becomes unpaused
func toggle_game_paused() -> bool:
	
	if get_tree().paused:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return false
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return true
