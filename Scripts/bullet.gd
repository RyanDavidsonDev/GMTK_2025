extends Node3D

const spin_speed = 1
const bob_speed = 3
const bob_height = .2
var bob_timer = 0

@onready var start_y : float = global_position.y

@export var _interactable : Interactable = null

func _ready() -> void:
	
	_interactable.hovered.connect(_on_interactable_hovered)
	_interactable.unhovered.connect(_on_interactable_unhovered)
	_interactable.selected.connect(_on_interactable_selected)

func _physics_process(delta: float) -> void:
	rotate(Vector3.UP, spin_speed*delta)
	bob_timer += delta
	
	var d = (sin(bob_timer * bob_speed) +1)/2
	global_position.y = start_y + (d*bob_height)

func _on_interactable_hovered() -> void:
	GameManager.hud_controller.interact_crosshair()

func _on_interactable_unhovered() -> void:
	GameManager.hud_controller.normal_crosshair()

func _on_interactable_selected() -> void:
	
	GameManager.hud_controller.show_next_bullet()
	GameManager.player_character.gun.bullet_count+=1
	
	queue_free()
