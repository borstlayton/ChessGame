class_name PermanentCard extends Card

func card_effect():
	SignalManager.bought_permanent_card.emit(0)
