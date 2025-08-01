extends RigidBody3D

const PivotPoint = preload("res://Scripts/pivot_point.gd")
const bdDoor = preload("res://Scripts/bookshelf_door.gd")
const TILT_ANGLE_DEGREES:float = -45


@export var index:int 
@export var door: bdDoor 

@onready var pivot_point: PivotPoint = $pivot_point

func interact(player:PlayerCharacter):
	print("activated book number", index)
	assert(door.has_method("receive_book_interact"), "the door on this book does not have an interact method")
	door.receive_book_interact(self)
	tilt_book()

func tilt_book():
	#print(basis)
	
	pivot_point.pivot_around_point(self, global_basis.z, TILT_ANGLE_DEGREES)
	
	#self.transform = 
	#
	#pivot_transform.rotated(
		#basis.y, deg_to_rad(TILT_ANGLE_DEGREES)).translated(to_global(gpivot_radius))
	#ss k
	#ps n
	#sp k
	#pp n
	
	#pivot_point.pivot_around_point(self, pivot_point.basis.y , TILT_ANGLE_DEGREES)

func reset_book():
	pivot_point.pivot_around_point(self, global_basis.z, -TILT_ANGLE_DEGREES)
	
	#this is where I'd revert all the physical changes made to the books
	#IF I HAD ANY
	#actual explanation is that they'll pop out from the shelves a little bit so we'll need to reset that
	#rotate_x(rad -TILT_ANGLE_DEGREES)
	return
