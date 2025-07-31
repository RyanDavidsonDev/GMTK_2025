extends RigidBody3D


@export var parent:Node3D 

func interact(player:PlayerCharacter):
	
	if(parent.has_method("interact")):
		parent.interact(player)
	else:
		printerr("ERROR: you're calling the interact function on an interact component that does not have interact in its parent")
