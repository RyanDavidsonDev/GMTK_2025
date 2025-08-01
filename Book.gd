extends RigidBody3D

@export var index:int 
@export var door: Door

func Interact(player:PlayerCharacter):
	print("book received Interact")
	assert(door.has_method("receive_book_interact"), "the door on this book does not have an interact method")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
