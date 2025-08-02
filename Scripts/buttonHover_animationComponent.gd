class_name BH_AnimationComponent extends Node

var original_text: String = ""
var hover_text: String = ""

func _ready():
	
	var button = get_parent()
	if button is Button:
		original_text = button.text
		hover_text = "— " + original_text + " —" #new hover text, add — dashes — like this!

		# Connect hover signals
		button.mouse_entered.connect(_on_button_mouse_entered)
		button.mouse_exited.connect(_on_button_mouse_exited)
	else:
		push_error("This AnimationComponent needs a better father figure (must be a child of a Button) :pensive emoji:.")

func _on_button_mouse_entered():
	var button = get_parent() as Button
	button.text = hover_text

func _on_button_mouse_exited():
	var button = get_parent() as Button
	button.text = original_text
