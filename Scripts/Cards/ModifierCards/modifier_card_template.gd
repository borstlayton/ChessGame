class_name ModifierCard extends Card

@onready var cannot_purchase = $CanPurchase
@onready var modifiable : bool = true
func _ready():
	cannot_purchase.hide()
	SignalManager.done_checking_modifiable_board.connect(can_purchase)
	
func can_purchase():
	modifiable = ModifierManager.is_modifiable
	print(modifiable)
	
	if not modifiable:
		cannot_purchase.show()
		
	elif modifiable:
		cannot_purchase.hide()
