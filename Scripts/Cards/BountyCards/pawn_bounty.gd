class_name PawnBounty extends Card

func card_effect():
	BountyManager.pawn_bounty_amount *= 1.25
	SignalManager.changed_bounty.emit()
