class_name BalanceModifier extends ModifierCard

func card_effect():
	SignalManager.modifier_purchased.emit(2)
