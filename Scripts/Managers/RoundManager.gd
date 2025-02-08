extends Node

var round_total = 0
var modifier_multiplier = 1
var last_used_modifier_multiplier = 1
var multiplier
var piece_total = 0

var piece_values = {
		"p": 1,  # Pawn
		"n": 3,  # Knight
		"b": 3,  # Bishop
		"r": 5,  # Rook
		"q": 9,  # Queen
		"k": 20   # King
	}
	
func _ready():
	SignalManager.done_getting_perma_bonus.connect(reset_round)
	SignalManager.next_level_selected.connect(reset_round_total)
	SignalManager.defeated.connect(reset_round_total)
func change_total(piece : String):
	# Check if the captured piece was white
	var white : bool = piece == piece.to_upper()

	# Multiplier to determine point addition or subtraction
	multiplier = 0 if white else 1
	# Determine the lowercase form of the piece name
	var piece_name = piece.to_lower()

	piece_total += piece_values[piece_name] * multiplier * modifier_multiplier
	
	match piece_name:
		"p":
			piece_total *= BountyManager.pawn_bounty_amount
		"q":
			piece_total *= BountyManager.queen_bounty_amount
		"n":
			piece_total *= BountyManager.knight_bounty_amount
		"r":
			piece_total *= BountyManager.rook_bounty_amount
		"b":
			piece_total *= BountyManager.bishop_bounty_amount
	
	round_total += piece_total
	piece_total = 0
	last_used_modifier_multiplier = modifier_multiplier
	modifier_multiplier = 1
	SignalManager.done_computing_piece_total.emit(piece_name)
	
func subtract_total(piece : String):
	var piece_name = piece.to_lower()
	
	round_total += piece_values[piece_name] * multiplier * modifier_multiplier
	modifier_multiplier = 1
	
func reset_round():
	
	round_total *= PermanentManager.perma_multiplier
	ShopManager.current_coin_amount += round_total
	PermanentManager.perma_multiplier = 1

func reset_round_total():
	round_total = 0
