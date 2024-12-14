class_name SpeedModifier extends ModifierCard

func card_effect():
	SignalManager.modifier_purchased.emit(1)
