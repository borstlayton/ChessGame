extends Control

@onready var sprite = $PieceTaken
@onready var piece_price_label = $PiecePriceLabel
@onready var total_piece = $PieceTotalLabel
func _ready():
	SignalManager.captured_piece.connect(determine_piece)
	SignalManager.done_computing_piece_total.connect(update_text)
	
func determine_piece(piece_taken : String, _piece_used : String, _column : int, _row : int, _past_column : int, _past_row : int):
	if piece_taken == piece_taken.to_lower(): #is black piece
		sprite.texture = load(BoardManager.assets[BoardManager.fen_dict[piece_taken]])
		
func update_sprite(updated_sprite : Texture2D):
	sprite.texture = updated_sprite

func update_text(piece_taken : String):
	var piece_value = RoundManager.piece_values[piece_taken]
	var bounty_amount = BountyManager.retreive_bounty(piece_taken)
	var modifier_amount = RoundManager.last_used_modifier_multiplier
	var price_text : String = str("Piece Value: ", piece_value, " X ", "Bounty: ", bounty_amount," X ", "Modifier Bonus: ", modifier_amount)
	piece_price_label.text = price_text
	total_piece.text = str(int(piece_value * bounty_amount * modifier_amount))
