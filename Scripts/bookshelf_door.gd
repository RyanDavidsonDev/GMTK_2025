extends Door

const Book = preload("res://Scripts/Book.gd")

var insertionOrder: Array[Book] = []

@export var books: Array[Book] = []

@export var open_door_automatically = true;

func _ready():
	for book in books:
		book.door = self

func receive_book_interact(book:Book):
	insertionOrder.append(book)
	if open_door_automatically && insertionOrder.size() >= books.size():
		if(_check_if_door_can_be_opened(GameManager.player_character)):
			open()
		
	return

func remove_book(book:Book):
	var index :int = insertionOrder.find(book) 
	
	if index != 1:
		insertionOrder.remove_at(index)

func _check_if_door_can_be_opened (player: PlayerCharacter) ->bool:
	if insertionOrder == books:
		GameManager.hud_controller.show_text_timer("The Way Is Open")
		return true
	else: if !open_door_automatically:
		GameManager.hud_controller.show_text_timer("that is not the correct order")
		for book in insertionOrder:
			book.untilt_book()
		insertionOrder.clear()
		return false
	else:
		print("_check_if_door_can_be_opened called and reached a point where idk how the code would've gotten her. If you're seeing this, good luck!")
		return false;
