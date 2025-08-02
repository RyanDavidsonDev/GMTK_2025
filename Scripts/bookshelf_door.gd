extends Door

const Book = preload("res://Scripts/Book.gd")

var insertionOrder: Array[Book] = []

@export var books: Array[Book] = []

func _ready():
	for book in books:
		book.door = self

func receive_book_interact(book:Book):
	insertionOrder.append(book)
	return

func remove_book(book:Book):
	var index :int = insertionOrder.find(book) 
	
	if index != 1:
		insertionOrder.remove_at(index)

func _check_if_door_can_be_opened(player: PlayerCharacter) ->bool:
	if insertionOrder == books:
		GameManager.hud_controller.show_text("The Way Is Open")
		return true
	else:		
		GameManager.hud_controller.show_text("that is not the correct order")
		for book in insertionOrder:
			book.untilt_book()
		insertionOrder.clear()
		return false
