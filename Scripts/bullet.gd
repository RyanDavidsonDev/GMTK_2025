extends RigidBody3D

const spin_speed = 1
const bob_speed = 3
const bob_height = .2
var bob_timer = 0

@onready var start_y : float = global_position.y

func interact(player:PlayerCharacter):
	GameManager.hud_controller.show_next_bullet()
	player.gun.bullet_count+=1
	print("count", player.gun.bullet_count)

	queue_free()
	#GameManager.hud_controller.show_text_timer("Press 'R' to reload")


func _physics_process(delta: float) -> void:
	rotate(Vector3.UP, spin_speed*delta)
	bob_timer += delta
	
	var d = (sin(bob_timer * bob_speed) +1)/2
	global_position.y = start_y + (d*bob_height)
	
	
