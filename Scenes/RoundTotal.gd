extends Label

func _process(_delta):
	text = str(RoundManager.round_total)
