extends RigidBody3D

const PivotPoint = preload("res://Scripts/pivot_point.gd")
const bdDoor = preload("res://Scripts/bookshelf_door.gd")
const TILT_ANGLE_DEGREES:float = -45

var tilted:bool = false

@export var index:int 
@export var door: bdDoor 

@onready var pivot_point: PivotPoint = $CollisionShape3D/PivotPoint

func interact(player:PlayerCharacter):
	if(!tilted):
		assert(door.has_method("receive_book_interact"), "the door on this book does not have an interact method")
		door.receive_book_interact(self)
		tilt_book()
	else :
		assert(door.has_method("remove_book"), "the door on this book does not have a remove_book method")
		door.remove_book(self)
		untilt_book()
		

func tilt_book():
	tilted = true;
	pivot_point.pivot_around_point(self, global_basis.z, TILT_ANGLE_DEGREES)
	
func untilt_book():
	tilted = false;
	pivot_point.pivot_around_point(self, global_basis.z, -TILT_ANGLE_DEGREES)
