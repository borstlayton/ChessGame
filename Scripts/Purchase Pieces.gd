extends HBoxContainer

@onready var pawn_button = $PawnPurchase
@onready var bishop_button = $BishopPurchase
@onready var knight_button = $KnightPurchase
@onready var queen_button = $QueenPurchase
@onready var rook_button = $RookPurchase
@onready var cancel_purchase_button = $CancelPurchase

@onready var pawn_price_label = $PawnPurchase/PawnPrice
@onready var bishop_price_label = $BishopPurchase/BishopPrice
@onready var knight_price_label = $KnightPurchase/KnightPrice
@onready var queen_price_label = $QueenPurchase/QueenPrice
@onready var rook_price_label = $RookPurchase/RookPrice

func _ready():
	cancel_purchase_button.hide()
	update_prices()
	
	SignalManager.complete_purchase.connect(update_prices)
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

func update_prices():
	pawn_price_label.text = str(ShopManager.coin_amount["P"])
	bishop_price_label.text = str(ShopManager.coin_amount["B"])
	knight_price_label.text = str(ShopManager.coin_amount["N"])
	queen_price_label.text = str(ShopManager.coin_amount["Q"])
	rook_price_label.text = str(ShopManager.coin_amount["R"])
