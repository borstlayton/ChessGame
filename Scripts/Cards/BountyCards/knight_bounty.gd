class_name KnightBounty extends Card


func card_effect():
	BountyManager.knight_bounty_amount *= 1.25
	SignalManager.changed_bounty.emit()
