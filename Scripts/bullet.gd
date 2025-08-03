extends RigidBody3D

func interact(player:PlayerCharacter):
	GameManager.hud_controller.show_next_bullet()
	player.gun.bullet_count+=1
	print("count", player.gun.bullet_count)

	queue_free()
	#GameManager.hud_controller.show_text_timer("Press 'R' to reload")
