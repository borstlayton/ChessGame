class_name PawnPromotionCard extends PermanentCard

func card_effect():
	SignalManager.bought_permanent_card.emit(4)
