class_name Interactable extends Area3D

signal hovered
signal unhovered
signal selected

@export var selectable_distance : float = 5.0

@export var _enabled : bool = true

func hover() -> void:
	if _enabled:
		hovered.emit()
	
func unhover() -> void:
	if _enabled:
		unhovered.emit()
	
func select() -> void:
	if _enabled:
		selected.emit()
		
func set_enabled(value:bool) -> void:
	if value == false:
		unhover()
	_enabled = value

func _exit_tree() -> void:
	unhover()
