extends Label

func _process(delta):
	text = "Round Total" + str(RoundManager.RoundTotal)