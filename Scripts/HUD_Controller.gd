class_name HUDController extends Node

@onready var reload_bar: TextureProgressBar = $"HUD/Reload Bar"
@onready var crosshair: TextureRect = $HUD/Control/crosshair
@onready var message_text: RichTextLabel = $"HUD/Message Text"
@onready var hide_text_timer: Timer = $Timer
@onready var game_over_panel: Panel = $"CanvasLayer/Game Over"
@onready var hud_layer: CanvasLayer = $HUD
@onready var key_icon: TextureRect = $"HUD/Key Icon"
@onready var boss_health: TextureProgressBar = $"HUD/Boss Health"

@onready var h_box_container: HBoxContainer = $HUD/HBoxContainer

var bullet_icon_active_queue: Array[TextureRect] = []
var ready_text_active_queue: Array[RichTextLabel] = []

var bullet_icon_inactive_queue: Array[TextureRect] = []
var ready_text_inactive_queue: Array[RichTextLabel] = []

@export var _pause_menu : Panel = null
signal sig_hide_continual_text()

const DEFAULT_MESSAGE_DURATION = 2

var target_image = load("res://assets/UI/crosshair_target.png")
var dot_image = load("res://assets/UI/crosshair_dot.png")
var interact_image = load("res://assets/UI/crosshair_hand.png")
	
func _ready():
	message_text.visible = false
	key_icon.visible = false
	GameManager.register_hud(self)
	
	for item :VBoxContainer in h_box_container.get_children():
		var bullet_icon:TextureRect = item.find_child("BulletIcon")
		bullet_icon_inactive_queue.push_back(bullet_icon)
		bullet_icon.visible = false
		
		var ready_text:RichTextLabel = item.find_child("RichTextLabel")
		ready_text_inactive_queue.push_back(ready_text)
		ready_text.text = ""


func show_next_bullet():	
	print("count", GameManager.player_character.gun.bullet_count)

	var bullet_icon:TextureRect = bullet_icon_inactive_queue.pop_front()
	bullet_icon_active_queue.push_back(bullet_icon)
	
	bullet_icon.visible = true

func hide_bullet():
	print("count", GameManager.player_character.gun.bullet_count)
	var bullet_icon:TextureRect = bullet_icon_active_queue.pop_back()
	bullet_icon_inactive_queue.push_front(bullet_icon)
	
	bullet_icon.visible = false



func show_next_ready_text():
	print("count", GameManager.player_character.gun.bullet_count)
	var ready_text:RichTextLabel = ready_text_inactive_queue.pop_front()
	ready_text_active_queue.push_back(ready_text)
	
	ready_text.text = "loaded";

func hide_ready_text():
	print("count", GameManager.player_character.gun.bullet_count)
	var ready_text:RichTextLabel = ready_text_active_queue.pop_back()
	ready_text_inactive_queue.push_front(ready_text)
	
	ready_text.text = "";


func clear_pending_hides():
	if(sig_hide_continual_text != null):
		var array = sig_hide_continual_text.get_connections()
		for sig in array:
			sig_hide_continual_text.emit()
	
	if hide_text_timer !=null:
		hide_text_timer.stop()

func show_text_continual(message: String):
	
	clear_pending_hides()
	
	message_text.text = message
	message_text.visible = true
	
	if !sig_hide_continual_text.is_connected(hide_text):
		
		sig_hide_continual_text.connect(hide_text)

func show_text_timer(message: String, duration: float = DEFAULT_MESSAGE_DURATION):
	message_text.text = message
	message_text.visible = true
	
	hide_text_timer.start(duration)
	await hide_text_timer.timeout
	print("after") #commented this out cause it was getting annoying. but the fact that it was pringitn so much might be a concern
	message_text.visible = false;
	
	return

func hide_text():
	message_text.visible = false
	

# Returns true if it opened and false if it closed
func toggle_pause_menu() -> bool:
	
	if _pause_menu.visible == false:
		_pause_menu.visible = true
		return true
	else:
		_pause_menu.visible = false
		return false


func hide_reload_bar():
	reload_bar.visible = false
	
func show_key():
	print("Key should show up now")
	key_icon.visible = true
	
func hide_key():
	print("Key Key Go Away!!!")
	key_icon.visible = false
	
func target_crosshair():
	crosshair.texture = target_image

func normal_crosshair():
	crosshair.texture = dot_image

func interact_crosshair():
	crosshair.texture = interact_image

func _process(delta: float) -> void:
	
	# Pause/unpause game
	if Input.is_action_just_pressed("pause_game"):
		
		var paused : bool = GameManager.toggle_game_paused()
		
		if paused:
			_pause_menu.visible = true
		else:
			_pause_menu.visible = false
	
	if GameManager.player_character.gun.is_reloading:
		var gun: Gun = GameManager.player_character.gun
		reload_bar.visible = true
		reload_bar.value = lerp(0, 100, (gun.reload_time - gun.reload_timer.time_left)/gun.reload_time)
	else :
		reload_bar.visible = false

func show_health_bar():
	boss_health.visible = true
	var enemy:EnemyAI = GameManager.enemy_ai
	boss_health.value = lerp(0,100, ( enemy.health)/enemy.max_health)

func _on_resume_pressed() -> void:
	
	GameManager.toggle_game_paused()
	_pause_menu.visible = false

func _on_quit_pressed() -> void:
	GameManager.load_menu()

func _on_wake_up_button_down() -> void:
	GameManager._cleanup_game()
	GameManager._load_game()
	#unpause?

func load_gameover_menu() -> void:
	game_over_panel.visible = true;
	hud_layer.visible = false;
	
