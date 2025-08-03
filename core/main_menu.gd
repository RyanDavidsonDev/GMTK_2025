extends Node

@export var _credits : CanvasLayer = null

func _on_play_pressed() -> void:
	GameManager.load_game()

func _on_credits_pressed() -> void:
	_credits.visible = true

# Go back from credits
func _on_exit_pressed() -> void:
	_credits.visible = false
