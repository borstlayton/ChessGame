class_name CrimsonModifier extends ModifierCard

func card_effect():
	SignalManager.modifier_purchased.emit(3)
