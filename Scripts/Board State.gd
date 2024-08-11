extends Label

func _process(delta):
	text = "Current State: " + str(BoardManager.current_board_state)
