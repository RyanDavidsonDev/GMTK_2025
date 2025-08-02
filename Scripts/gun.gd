class_name Gun extends Node3D

@export var reload_time: float = 3

@onready var reload_timer: Timer = $reload_timer

var bullet_count: int = 0

var is_loaded: bool = false
var is_reloading: bool = false

func _ready() ->void:
	reload_timer.timeout.connect(finish_reload)

func try_fire():
	if is_loaded:
		fire()
	else :
		GameManager.hud_controller.show_text("my gun isn't loaded")

func fire():
	print("pew pew")
	is_loaded = false
	bullet_count -=1 


func reload():
	if(bullet_count<1):
		GameManager.hud_controller.show_text("I don't have any bullets")
		return
	if(!is_reloading):
		is_reloading = true
		
		print("starting reload")
		reload_timer.start(reload_time)
		return;

func finish_reload()->void:
	is_reloading = false
	print("finished reload")
	is_loaded = true
	bullet_count-=1
