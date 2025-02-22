class_name PermanentCard extends Card

@onready var cannot_purchase = $CanPurchase
@onready var slot_available : bool = true

func _ready():
	
	super()
	cannot_purchase.hide()
	SignalManager.added_permanent_card.connect(can_purchase)
	
func can_purchase():
	slot_available = PermanentManager.slots_available
	
	if not slot_available:
		cannot_purchase.show()
		can_buy = false
		
	elif slot_available:
		cannot_purchase.hide()
		can_buy = true
		
func card_effect():
	SignalManager.bought_permanent_card.emit(0)
