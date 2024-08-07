extends Label


func _process(delta):
	text = "Level: " + str(BoardManager.current_level)
