class_name PauseMenu extends Panel

@onready var hud_controller :HUDController = get_parent().get_parent()
@onready var quit_game_button: Button = $"VBoxContainer/Button Stack/Quit_Game_Margin/Quit_Game_Button"

@onready var quit_menu_button: Button = $"VBoxContainer/Button Stack/Quit_Menu_margin/Quit_Menu_Button"
@onready var resume: Button = $"VBoxContainer/Button Stack/Resume/Resume"


func _on_quit_pressed() -> void:
	GameManager.load_menu()

func _ready() -> void:
	hud_controller.pause_menu = self
	print("hi")
	quit_game_button.pressed.connect(func(): get_tree().quit())
	resume.pressed.connect(_resume)
	quit_menu_button.pressed.connect(quit_menu)
	pass

func _resume():
	assert(hud_controller)
	hud_controller.receive_resume()

func quit_menu():
	GameManager.load_menu()
	pass
