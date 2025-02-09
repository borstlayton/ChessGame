class_name RookBounty extends Card

func card_effect():
	SignalManager.bought_bounty.emit(5)
