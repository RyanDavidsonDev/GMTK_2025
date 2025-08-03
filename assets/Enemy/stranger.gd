extends Node3D

@onready var animation_player = $AnimationPlayer
 
func _ready():
	# This is how you'll get the animations!!!!!!!!!!!!!!
	#Walk, Flop, Rise Animations in currently, wiill push Attack animation next
	animation_player.play("StrangerAnimLibrary/Walk Animation")

#func _process(delta):
	
	
