class_name Gun extends Node3D

@export var reload_time: float = 3

@onready var reload_timer: Timer = $reload_timer

var bullet_count: int = 1

var is_loaded: bool = false
var is_reloading: bool = false

func _ready() ->void:
	reload_timer.timeout.connect(finish_reload)

func try_fire():
	if is_loaded:
		fire()
	else :
		GameManager.hud_controller.show_text_timer("\"my gun isn't loaded\"")

func fire():
	print("\"bang\"")
	GameManager.player_character.play_animation("GunAnimLibrary/Firing Hand")
	#GameManager.player_character.play_animation_2("Armature|ArmatureAction")
	GameManager.hud_controller.show_text_timer("\"bang\"")
	
	GameManager.hud_controller.hide_bullet()
	GameManager.hud_controller.hide_ready_text()
	
	is_loaded = false

func interrupt_reload():
	if(is_reloading):
		GameManager.player_character.num_times_tried_reload+=1
		var times : int  = GameManager.player_character.num_times_tried_reload
		if times > 4 && times <15:
			print("hi")
			GameManager.hud_controller.show_text_timer("\"I'm not familiar enough with this gun to reload it and keep walking \n I should put some distance between The Stranger and Myself \"", 4)
			
	is_reloading = false
	reload_timer.stop()
	#send out any signals we need to

func reload():
	if(bullet_count<1):
		GameManager.hud_controller.show_text_timer("\"I don't have any bullets\"")
		return
	if(!is_reloading):
		GameManager.player_character.play_animation("GunAnimLibrary/Reloading Handeres")
		await get_tree().create_timer(.23).timeout
		GameManager.player_character.play_animation_2("Armature|ArmatureAction")
		
		if GameManager.player_character._input_move_direction != Vector2.ZERO:
			GameManager.player_character._input_move_direction != Vector2.ZERO
			GameManager.hud_controller.show_text_timer("\"I'm not familiar enough with this gun to reload it and keep walking\"")
			
		
		is_reloading = true
		
		
		print("starting reload")
		reload_timer.start(reload_time)
		return;

func finish_reload()->void:
	is_reloading = false
	GameManager.hud_controller.show_text_timer("It's ready to fire")
	GameManager.hud_controller.show_next_ready_text()
	is_loaded = true
	bullet_count-=1
