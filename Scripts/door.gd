class_name Door extends Node3D


@onready var root: Node3D = $"."

@export var OutwardRotationDeg: float = 90;
@export var RotationTimeSec: float = .8;
@export var NeedsKey: bool = false;

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
#@onready var pivot_point: PivotPoint = $PivotPoint

@onready var pivot_point: PivotPoint = $PivotPoint

@export var _interactable : Interactable = null

#@onready var rigid_body_3d: RigidBody3D = $PivotPoint/RigidBody3D
#@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
#@onready var pivot_point: PivotPoint = $PivotPoint

var doorIsOpening : bool = false;
var doorIsAlreadyOpen : bool = false;

func _ready():
	
	rigid_body_3d.body_entered.connect(receiveCollision)
	
	_interactable.hovered.connect(_on_interactable_hovered)
	_interactable.unhovered.connect(_on_interactable_unhovered)
	_interactable.selected.connect(_on_interactable_selected)
	
func _physics_process(_delta):
	
	if(doorIsOpening && !doorIsAlreadyOpen):
		var NextRotDeg: float = OutwardRotationDeg * inverse_lerp( 0.0, RotationTimeSec,  _delta)
		pivot_point.rotate_y(deg_to_rad(NextRotDeg))
	
		if( pivot_point.rotation_degrees.y >= OutwardRotationDeg):
			print("rotation ", pivot_point.rotation_degrees.y)
			pivot_point.rotation_degrees.y= OutwardRotationDeg
			doorIsOpening = false 
			doorIsAlreadyOpen = true

func receiveCollision(body):
	if(body.is_in_group("BlockDoorTurn")):
		doorIsAlreadyOpen = true
		doorIsOpening = false

func resetDoor():
	doorIsAlreadyOpen = false
	doorIsOpening = false
	pivot_point.rotation_degrees.y= 0
	#pivot_point.rotate_y(-pivot_point.rotation.y)
	

func open() -> void:
	pivot_point.pivot_around_point(self, global_basis.y, OutwardRotationDeg, RotationTimeSec)
	if _interactable:
		_interactable.set_enabled(false)
	GameManager.emit_door_signal()
	#doorIsOpening = true;
	#root.translate(Vector3(1,1,1))	

#intended to be overridden with other doors
func _check_if_door_can_be_opened(player: PlayerCharacter) ->bool:
	if(NeedsKey):		
		assert("has_key" in player, "ERROR: player param in door.Interact() does not have the HasKey property")
		
		if(!player.has_key):
			GameManager.hud_controller.show_text_timer("I need a key")
			return false
		else:
			player.has_key = false
			GameManager.hud_controller.hide_key() #opens door & hides key icon
			return true
			
	else :
		return true


func _on_button_pressed() -> void:
	if(!doorIsAlreadyOpen):
		open()
	else:
		resetDoor()
		


func _on_interactable_hovered() -> void:
	GameManager.hud_controller.interact_crosshair()

func _on_interactable_unhovered() -> void:
	GameManager.hud_controller.normal_crosshair()

func _on_interactable_selected() -> void:
	
	if(_check_if_door_can_be_opened(GameManager.player_character)):
		open()
