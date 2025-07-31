extends Node

@onready var root: Node3D = $"."

@export var OutwardRotationDeg: float = 90;
@export var RotationTimeSec: float = .8;

@onready var pivot_point: Node3D = $PivotPoint

var doorIsOpening : bool = false;
var doorIsAlreadyOpen : bool = false;

func _ready():
	print("ready")
	
func _physics_process(_delta):
	
	if(doorIsOpening && !doorIsAlreadyOpen):
		var NextRotDeg: float = OutwardRotationDeg * inverse_lerp( 0.0, RotationTimeSec,  _delta)
		pivot_point.rotate_y(deg_to_rad(NextRotDeg))
	
		if(rad_to_deg( pivot_point.rotation.y) >= OutwardRotationDeg):
			pivot_point.rotation.y= (deg_to_rad(OutwardRotationDeg))
			doorIsOpening = false 
			doorIsAlreadyOpen = true
		#todo: add another check for if we collide against anything like a wall
		
func resetDoor():
	doorIsAlreadyOpen = false
	doorIsOpening = false
	pivot_point.rotation.y= (deg_to_rad(0))
	

func open():
	doorIsOpening = true;
	#root.translate(Vector3(1,1,1))
	print("received openDoor func")


func _on_button_pressed() -> void:
	if(!doorIsAlreadyOpen):
		open()
	else:
		resetDoor()
		
