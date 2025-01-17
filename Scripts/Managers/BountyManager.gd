extends Node

var knight_bounty_amount
var queen_bounty_amount
var rook_bounty_amount
var bishop_bounty_amount
var pawn_bounty_amount

var current_bounty_cards = [-1,-1]

func _ready():
	knight_bounty_amount = 1
	queen_bounty_amount = 1
	rook_bounty_amount = 1
	bishop_bounty_amount = 1
	pawn_bounty_amount = 1
	
	SignalManager.bought_bounty.connect(update_bounty)
	
func retreive_bounty(piece_name):
	match piece_name:
		"k":
			return 1
		"p":
			return pawn_bounty_amount
		"n":
			return knight_bounty_amount
		"q":
			return queen_bounty_amount
		"r":
			return rook_bounty_amount
			
func update_bounty(cardID : int):
	match cardID:
		1:
			bishop_bounty_amount = 2
		2:
			knight_bounty_amount = 2
		3:
			pawn_bounty_amount = 2
		4:
			queen_bounty_amount = 2
		5:
			rook_bounty_amount = 2
