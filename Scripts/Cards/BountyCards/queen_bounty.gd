class_name QueenBounty extends Card

func card_effect():
	BountyManager.queen_bounty_amount *= 1.25
	SignalManager.bought_bounty.emit(4)
