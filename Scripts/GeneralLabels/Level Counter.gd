extends Label


func _process(_delta):
	text = "Level: " + str(BoardManager.current_level)
