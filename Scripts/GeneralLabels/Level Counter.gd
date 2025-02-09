extends Label


func _process(_delta):
	text = str((BoardManager.current_level+1), "/20")
