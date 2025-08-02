class_name HUDController extends Node

@onready var reload_bar: TextureProgressBar = $"HUD/Reload Bar"
@onready var crosshair: TextureRect = $HUD/Control/crosshair
@onready var message_text: RichTextLabel = $"HUD/Message Text"

@export var _pause_menu : Panel = null

const DEFAULT_MESSAGE_DURATION = 2

func _ready():
	message_text.visible = false
	GameManager.register_hud(self)

func show_text(message: String, duration: float = DEFAULT_MESSAGE_DURATION):
	message_text.text = message
	message_text.visible = true
	
	await get_tree().create_timer(duration).timeout
	#print("after") #commented this out cause it was getting annoying. but the fact that it was pringitn so much might be a concern
	message_text.visible = false;
	
	return

func hide_text():
	message_text.visible = false
	

# Returns true if it opened and false if it closed
func toggle_pause_menu() -> bool:
	
	if _pause_menu.visible == false:
		_pause_menu.visible = true
		return true
	else:
		_pause_menu.visible = false
		return false


func hide_reload_bar():
	reload_bar.visible = false

func _process(delta: float) -> void:
	
	# Pause/unpause game
	if Input.is_action_just_pressed("pause_game"):
		
		var paused : bool = GameManager.toggle_game_paused()
		
		if paused:
			_pause_menu.visible = true
		else:
			_pause_menu.visible = false
	
	if GameManager.player_character.gun.is_reloading:
		var gun: Gun = GameManager.player_character.gun
		reload_bar.visible = true
		reload_bar.value = lerp(0, 100, (gun.reload_time - gun.reload_timer.time_left)/gun.reload_time)
	else :
		reload_bar.visible = false

func _on_resume_pressed() -> void:
	
	GameManager.toggle_game_paused()
	_pause_menu.visible = false


func _on_quit_pressed() -> void:
	
	GameManager.load_menu()
