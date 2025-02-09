class_name QueenBounty extends Card

func card_effect():
	SignalManager.bought_bounty.emit(4)
