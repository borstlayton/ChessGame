extends Label

func _process(_delta):
	text = "Current State: " + str(BoardManager.current_board_state)
