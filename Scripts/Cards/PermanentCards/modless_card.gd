class_name ModlessCard extends PermanentCard

func card_effect():
	SignalManager.bought_permanent_card.emit(2)
