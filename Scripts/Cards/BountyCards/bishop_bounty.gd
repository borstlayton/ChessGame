class_name BishopBounty extends Card

func card_effect():
	BountyManager.bishop_bounty_amount *= 1.5
	SignalManager.changed_bounty.emit()
