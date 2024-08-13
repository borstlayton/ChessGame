extends HBoxContainer

@onready var cancel_purchase_button = $CancelPurchase

func _ready():
	cancel_purchase_button.hide()

func _on_pawn_purchase_button_down():
	start_purchase("p")
func _on_bishop_purchase_button_down():
	start_purchase("b")
func _on_knight_purchase_button_down():
	start_purchase("n")
func _on_queen_purchase_button_down():
	start_purchase("q")
func _on_rook_purchase_button_down():
	start_purchase("r")

func _on_cancel_purchase_button_down():
	ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
	ShopManager.current_piece = ""
	cancel_purchase_button.hide()
func start_purchase(piece_type : String):
	if ShopManager.current_state == ShopManager.piece_purchase_states.PURCHASE_IDLE:
		cancel_purchase_button.show()
		ShopManager.purchase_piece(piece_type)

