extends RigidBody3D


func interact(player:PlayerCharacter):
	if(player.has_key):
		print("you cannot hold more than one key")
	else :
		print("collected key")
		player.has_key = true;
		queue_free()
