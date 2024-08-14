extends HBoxContainer

@onready var pawn_button = $PawnPurchase
@onready var bishop_button = $BishopPurchase
@onready var knight_button = $KnightPurchase
@onready var queen_button = $QueenPurchase
@onready var rook_button = $RookPurchase
@onready var cancel_purchase_button = $CancelPurchase

func _ready():
	cancel_purchase_button.hide()
	SignalManager.complete_purchase.connect(show_buttons)
	
func _on_pawn_purchase_button_down():
	start_purchase("P")
func _on_bishop_purchase_button_down():
	start_purchase("B")
func _on_knight_purchase_button_down():
	start_purchase("N")
func _on_queen_purchase_button_down():
	start_purchase("Q")
func _on_rook_purchase_button_down():
	start_purchase("R")

func _on_cancel_purchase_button_down():
	ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
	ShopManager.current_piece = ""
	show_buttons()
func start_purchase(piece_type : String):
	hide_buttons()
	if ShopManager.current_state == ShopManager.piece_purchase_states.PURCHASE_IDLE:
		ShopManager.purchase_piece(piece_type)

func hide_buttons():
	cancel_purchase_button.show()
	pawn_button.hide()
	bishop_button.hide()
	knight_button.hide()
	queen_button.hide()
	rook_button.hide()
	
func show_buttons():
	cancel_purchase_button.hide()
	pawn_button.show()
	bishop_button.show()
	knight_button.show()
	queen_button.show()
	rook_button.show()
