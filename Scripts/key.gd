extends Node3D

@export var _interactable : Interactable = null

func _ready():

	_interactable.hovered.connect(_on_interactable_hovered)
	_interactable.unhovered.connect(_on_interactable_unhovered)
	_interactable.selected.connect(_on_interactable_selected)

func _on_interactable_hovered() -> void:
	GameManager.hud_controller.interact_crosshair()

func _on_interactable_unhovered() -> void:
	GameManager.hud_controller.normal_crosshair()

func _on_interactable_selected() -> void:
	
	if(GameManager.player_character.has_key):
		GameManager.hud_controller.show_text_continual("My hands are full. I can't hold more than one Key")
	else :
		GameManager.player_character.has_key = true;
		GameManager.hud_controller.show_key()
		queue_free()
