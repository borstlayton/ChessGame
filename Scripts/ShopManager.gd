extends Node

var current_state : piece_purchase_states
var current_piece : String
var current_piece_scene
enum piece_purchase_states{PURCHASE_IDLE, MOVING_PIECE, PIECE_PLACED}

func purchase_piece(piece_type : String):
	current_piece = piece_type
	SignalManager.purchased_piece.emit(piece_type)


