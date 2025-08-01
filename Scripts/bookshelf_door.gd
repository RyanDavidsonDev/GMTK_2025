extends Door

const Book = preload("res://Scripts/Book.gd")

var insertionOrder: Array[int] = []
@export var intendedOrder: Array[int] = []

@export var books: Array[Book] = []

func _ready():
	for book in books:
		book.door = self

func receive_book_interact(index:int):
	insertionOrder.append(index)
	return


func _check_if_door_can_be_opened(player: PlayerCharacter) ->bool:
	if insertionOrder == intendedOrder:
		print("The way is open")
		return true
	else:
		print("that is not the correct order")
		for book in books:
			book.reset_book()
		insertionOrder.clear()
		return false
