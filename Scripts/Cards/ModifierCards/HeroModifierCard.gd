class_name HeroModifierCard extends ModifierCard

func card_effect():
	SignalManager.modifier_purchased.emit(5)
