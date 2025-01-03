class_name BuzzerBeaterCard extends PermanentCard

func card_effect():
	SignalManager.bought_permanent_card.emit(1)
