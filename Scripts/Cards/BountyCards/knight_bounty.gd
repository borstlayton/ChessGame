class_name KnightBounty extends Card


func card_effect():
	SignalManager.bought_bounty.emit(2)
