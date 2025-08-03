extends Node

@export var game_scene : PackedScene = null
@export var menu_scene : PackedScene = null

var late_ready: Signal

var player_character : PlayerCharacter = null
var enemy_ai : EnemyAI = null
var hud_controller : HUDController = null

var _in_game : bool = false

func register_player_character(instance: PlayerCharacter) -> void:
	
	if player_character != null:
		printerr("Reference to player character is already set. Ensure cleanup of previous character before registering a new one.")
		return
	
	player_character = instance
	hud_controller.show_next_bullet()
	
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
	load_game()
	
	toggle_game_paused()
	hud_controller.load_gameover_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#_load_game()
	
func load_menu() -> void:
	
	get_tree().change_scene_to_packed(menu_scene)
	
	_in_game = false
	
func load_game() -> void:
	
	player_character = null
	enemy_ai = null
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	get_tree().change_scene_to_packed(game_scene)
	
	_in_game = true
func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#_load_game.call_deferred()
	late_ready.emit()

# Returns true if game becomes paused and false if it becomes unpaused
func toggle_game_paused() -> bool:
	
	if _in_game == false:
		return false
	
	if get_tree().paused:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return false
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return true
