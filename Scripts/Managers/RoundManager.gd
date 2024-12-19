extends Node

var round_total = 0
var modifier_multiplier = 1
var multiplier

var piece_values = {
		"p": 1,  # Pawn
		"n": 3,  # Knight
		"b": 3,  # Bishop
		"r": 5,  # Rook
		"q": 9,  # Queen
		"k": 20   # King
	}
	
func _ready():
	SignalManager.beat_level.connect(reset_round)
	
func change_total(piece : String):
	# Check if the captured piece was white
	var white : bool = piece == piece.to_upper()

	# Multiplier to determine point addition or subtraction
	multiplier = 0 if white else 1
	# Determine the lowercase form of the piece name
	var piece_name = piece.to_lower()

	round_total += piece_values[piece_name] * multiplier * modifier_multiplier
	modifier_multiplier = 1

func subtract_total(piece : String):
	var piece_name = piece.to_lower()
	
	round_total += piece_values[piece_name] * multiplier * modifier_multiplier
	modifier_multiplier = 1
	
func reset_round():
	ShopManager.current_coin_amount += round_total
	round_total = 0
