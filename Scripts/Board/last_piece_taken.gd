extends Control

@onready var sprite = $PieceTaken
@onready var piece_price_label = $PiecePriceLabel
func _ready():
	SignalManager.captured_piece.connect(determine_piece)
	
func determine_piece(piece_taken : String, _piece_used : String, _column : int, _row : int, _past_column : int, _past_row : int):
	if piece_taken == piece_taken.to_lower(): #is black piece
		sprite.texture = load(BoardManager.assets[BoardManager.fen_dict[piece_taken]])
		update_text(piece_taken)
		
func update_sprite(updated_sprite : Texture2D):
	sprite.texture = updated_sprite

func update_text(piece_taken : String):
	var piece_value = RoundManager.piece_values[piece_taken]
	var bounty_amount = BountyManager.retreive_bounty(piece_taken)
	var modifier_amount = RoundManager.last_used_modifier_multiplier
	var price_text : String = str("Piece Value: ", piece_value, " X ", "Bounty: ", bounty_amount," X ", "Modifier Bonus: ", modifier_amount)
	piece_price_label.text = price_text
