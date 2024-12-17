extends Label

func _process(_delta):
	text = "Round Total: " + str(RoundManager.round_total)
