extends Node

var current_state : piece_purchase_states
var current_piece : String
var current_piece_scene
var purchased_pieces_locations = []
var purchased_pieces_names = []
enum piece_purchase_states{PURCHASE_IDLE, MOVING_PIECE, PIECE_PLACED}

func _ready():
	SignalManager.placed_purchased_piece.connect(add_piece)
func purchase_piece(piece_type : String):
	current_piece = piece_type
	SignalManager.purchased_piece.emit(piece_type)

func add_piece(location : Vector2, piece : String):
	purchased_pieces_locations.append(location)
	purchased_pieces_names.append(piece)
