class_name ModifierCard extends Card

@onready var cannot_purchase = $CanPurchase
@onready var modifiable : bool = true

func _ready():
	super()
	cannot_purchase.hide()
	SignalManager.done_checking_modifiable_board.connect(can_purchase)
	
func can_purchase():
	modifiable = ModifierManager.is_modifiable
	print(modifiable)
	
	if not modifiable:
		cannot_purchase.show()
		buy_panel.hide()
		
	elif modifiable:
		cannot_purchase.hide()
		buy_panel.show()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and modifiable:
			buy_panel.show()
			collision_shape.disabled = true

func card_effect():
	SignalManager.emit_signal("modifier_purchased")
