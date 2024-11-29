extends Node

var round_total = 0

func _ready():
	SignalManager.next_level_selected.connect(reset_round)
	
func change_total(piece : String):
	# Check if the captured piece was white
	var white : bool = piece == piece.to_upper()

	# Multiplier to determine point addition or subtraction
	var multiplier = -1 if white else 1

	# Determine the lowercase form of the piece name
	var piece_name = piece.to_lower()

	# Dictionary of chess piece values
	var piece_values = {
		"p": 1,  # Pawn
		"n": 3,  # Knight
		"b": 3,  # Bishop
		"r": 5,  # Rook
		"q": 8,  # Queen
		"k": 20   # King
	}
	round_total += piece_values[piece_name] * multiplier
	
func reset_round():
	ShopManager.current_coin_amount += round_total
	round_total = 0
