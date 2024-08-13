extends Node

var current_state : piece_purchase_states
var current_piece : String
enum piece_purchase_states{PURCHASE_IDLE, MOVING_PIECE, PIECE_PLACED}

func purchase_piece(piece_type : String):
	current_state = piece_purchase_states.MOVING_PIECE
	current_piece = piece_type
	print(current_piece)
