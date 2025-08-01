extends RigidBody3D

@export var index:int 
const bdDoor = preload("res://Scripts/bookshelf_door.gd")
@export var door: bdDoor 

func interact(player:PlayerCharacter):
	print("activated book number", index)
	assert(door.has_method("receive_book_interact"), "the door on this book does not have an interact method")
	door.receive_book_interact(index)
	
func reset_book():
	#this is where I'd revert all the physical changes made to the books
	#IF I HAD ANY
	#actual explanation is that they'll pop out from the shelves a little bit so we'll need to reset that
	return
