extends RigidBody3D

func interact(player:PlayerCharacter):
	queue_free()
	player.gun.bullet_count+=1
