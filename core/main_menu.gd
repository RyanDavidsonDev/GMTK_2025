extends Node

@export var _credits : CanvasLayer = null
@onready var quit: Button = $CanvasLayer/Panel/VBoxContainer/MarginContainer4/quit

func ready():
	quit.pressed.connect(func(): get_tree().quit())

func _on_play_pressed() -> void:
	GameManager.load_game()

func _on_credits_pressed() -> void:
	_credits.visible = true

# Go back from credits
func _on_exit_pressed() -> void:
	_credits.visible = false
