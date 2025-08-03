extends RigidBody3D


func interact(player:PlayerCharacter):
	if(player.has_key):
		GameManager.hud_controller.show_text_continual("My hands are full. I can't hold more than one Key")
	else :
		player.has_key = true;
		GameManager.hud_controller.show_key()
		queue_free()
