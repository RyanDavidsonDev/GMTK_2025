extends Node

@onready var root: Node3D = $"."

@export var OutwardRotationDeg: float = 90;
@export var RotationTimeSec: float = .8;
@export var NeedsKey: bool = false;

@onready var rigid_body_3d: RigidBody3D = $PivotPoint/RigidBody3D
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var pivot_point: Node3D = $PivotPoint

var doorIsOpening : bool = false;
var doorIsAlreadyOpen : bool = false;

func _ready():
	rigid_body_3d.body_entered.connect(receiveCollision)
	return
	
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
	print("ping")
	if(body.is_in_group("BlockDoorTurn")):
		doorIsAlreadyOpen = true
		doorIsOpening = false

func resetDoor():
	print("rotation ", pivot_point.rotation_degrees.y)
	doorIsAlreadyOpen = false
	doorIsOpening = false
	pivot_point.rotation_degrees.y= 0
	#pivot_point.rotate_y(-pivot_point.rotation.y)
	print("rotation ", pivot_point.rotation_degrees.y)
	

func open() -> void:
	print("rotation ", pivot_point.rotation_degrees.y)
	doorIsOpening = true;
	#root.translate(Vector3(1,1,1))
	print("received openDoor func")

func interact(player: Node3D) -> void :
	if(NeedsKey):		
		assert("HasKey" in player, "ERROR: player param in door.Interact() does not have the HasKey property")
		if(!player.HasKey):
			print("you need a key")
			return
	
	open()


func _on_button_pressed() -> void:
	if(!doorIsAlreadyOpen):
		open()
	else:
		resetDoor()
		
