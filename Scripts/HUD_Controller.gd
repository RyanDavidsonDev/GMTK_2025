class_name HUDController extends Node

@onready var reload_bar: TextureProgressBar = $"HUD/Reload Bar"
@onready var crosshair: TextureRect = $HUD/Control/crosshair
@onready var message_text: RichTextLabel = $"HUD/Message Text"

func _ready():
	GameManager.register_hud(self)

func show_text(message: String):
	message_text.text = message
	message_text.visible = true
	
	
	return
	
