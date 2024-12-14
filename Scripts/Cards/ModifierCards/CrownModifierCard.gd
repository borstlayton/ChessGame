class_name CrownCardModifier extends ModifierCard

func card_effect():
	SignalManager.modifier_purchased.emit(4)
