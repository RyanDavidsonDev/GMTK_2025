extends Node

@onready var credits_menu: Node = $CreditsMenu
#@onready var credits_canvas_layer: CanvasLayer = %Credits_canvasLayer
@onready var credits_canvas_layer: CanvasLayer = $CreditsMenu/Credits_canvasLayer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_down() -> void:
	GameManager._load_game()

func _on_credits_button_down() -> void:
	credits_canvas_layer.visible = true


func _on_exit_button_down() -> void:
	print("hi")
	credits_canvas_layer.visible = false
