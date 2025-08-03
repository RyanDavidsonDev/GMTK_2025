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
	GameManager.hud_controller.show_text_timer("\"bang\"")
	
	is_loaded = false
	bullet_count -=1 

func interrupt_reload():
	is_reloading = false
	reload_timer.stop()
	#send out any signals we need to

func reload():
	if(bullet_count<1):
		GameManager.hud_controller.show_text_timer("\"I don't have any bullets\"")
		return
	if(!is_reloading):
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
	is_loaded = true
	bullet_count-=1
