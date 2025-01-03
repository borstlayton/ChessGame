class_name NoEnemiesCard extends PermanentCard

func card_effect():
	SignalManager.bought_permanent_card.emit(3)
