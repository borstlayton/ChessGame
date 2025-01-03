class_name TimelyKing extends PermanentCard

func card_effect():
	SignalManager.bought_permanent_card.emit(6)
