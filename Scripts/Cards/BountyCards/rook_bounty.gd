class_name RookBounty extends Card

func card_effect():
	BountyManager.rook_bounty_amount *= 1.25
	SignalManager.changed_bounty.emit()
