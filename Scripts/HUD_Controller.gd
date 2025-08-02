class_name HUDController extends Node

@onready var reload_bar: TextureProgressBar = $"HUD/Reload Bar"
@onready var crosshair: TextureRect = $HUD/Control/crosshair
@onready var message_text: RichTextLabel = $"HUD/Message Text"

@export var _pause_menu : Panel = null

var _pause_menu_open : bool = false

func _ready():
	GameManager.register_hud(self)

func show_text(message: String):
	message_text.text = message
	message_text.visible = true
	
	
	return
	
func open_pause_menu() -> bool:
	
	if _pause_menu_open == true:
		printerr("Attempting to open pause menu but pause menu is already open")
		return false
		
	_pause_menu.visible = true
	_pause_menu_open = true
	return true
	
func close_pause_menu() -> bool:
	
	if _pause_menu_open == false:
		printerr("Attempting to close pause menu but pause menu is already closed")
		return false
		
	_pause_menu.visible = false
	_pause_menu_open = false
	return true
