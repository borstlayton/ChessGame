class_name BishopBounty extends Card

func card_effect():
	BountyManager.bishop_bounty_amount *= 1.25
	SignalManager.bought_bounty.emit(1)
