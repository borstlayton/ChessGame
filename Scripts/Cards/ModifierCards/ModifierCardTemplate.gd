class_name ModifierCard extends Card

@onready var cannot_purchase = $CanPurchase
@onready var modifiable : bool = true
func _ready():
	super()
	cannot_purchase.hide()
	SignalManager.done_checking_modifiable_board.connect(can_purchase)
func can_purchase():
	modifiable = ModifierManager.is_modifiable
	
	if not modifiable:
		cannot_purchase.show()
		
	elif modifiable:
		cannot_purchase.hide()

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and modifiable:
			buy_panel.show()
			collision_shape.disabled = true

func card_effect():
	SignalManager.modifier_purchased.emit(0)


func release_card():
	self.queue_free()
