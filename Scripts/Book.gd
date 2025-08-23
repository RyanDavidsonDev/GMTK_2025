extends Node3D

const PivotPoint = preload("res://Scripts/pivot_point.gd")
const bdDoor = preload("res://Scripts/bookshelf_door.gd")
const TILT_ANGLE_DEGREES:float = -45

var tilted:bool = false

@export var index:int 
@export var door: bdDoor 

@onready var pivot_point: PivotPoint = $PivotPoint

@export var _interactable : Interactable = null

func tilt_book():
	tilted = true;
	pivot_point.pivot_around_point(self, global_basis.z, TILT_ANGLE_DEGREES)
	
func untilt_book():
	tilted = false;
	pivot_point.pivot_around_point(self, global_basis.z, -TILT_ANGLE_DEGREES)

func _ready() -> void:
	
	_interactable.hovered.connect(_on_interactable_hovered)
	_interactable.unhovered.connect(_on_interactable_unhovered)
	_interactable.selected.connect(_on_interactable_selected)

func _on_interactable_hovered() -> void:
	GameManager.hud_controller.interact_crosshair()

func _on_interactable_unhovered() -> void:
	GameManager.hud_controller.normal_crosshair()

func _on_interactable_selected() -> void:
	
	if(!tilted):
		assert(door.has_method("receive_book_interact"), "the door on this book does not have an interact method")
		door.receive_book_interact(self)
		tilt_book()
	else :
		assert(door.has_method("remove_book"), "the door on this book does not have a remove_book method")
		door.remove_book(self)
		untilt_book()
