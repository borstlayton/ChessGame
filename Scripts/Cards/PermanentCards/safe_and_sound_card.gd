class_name SafeAndSoundCard extends PermanentCard

func card_effect():
	SignalManager.bought_permanent_card.emit(5)