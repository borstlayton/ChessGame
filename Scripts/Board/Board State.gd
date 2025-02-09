extends Label

func _process(_delta):
	text = str(BoardManager.current_board_state)
