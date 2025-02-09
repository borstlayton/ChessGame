class_name BishopBounty extends Card

func card_effect():
	SignalManager.bought_bounty.emit(1)
