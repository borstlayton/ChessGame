extends Node

var current_coin_amount : int
var current_state : piece_purchase_states
var current_piece : String
var current_piece_scene
var purchased_pieces_locations = []
var purchased_pieces_names = []
var purchasable_tiles = []
enum piece_purchase_states{PURCHASE_IDLE, MOVING_PIECE, PIECE_PLACED}

var coin_amount := {
	"P": 1,
	"B": 3,
	"N": 3,
	"R": 5,
	"Q": 8,
}
func _ready():
	SignalManager.placed_purchased_piece.connect(add_piece)
	current_coin_amount = 100
func purchase_piece(piece_type : String):
	current_piece = piece_type
	SignalManager.purchased_piece.emit(piece_type)

func add_piece(location : Vector2, piece : String):
	purchased_pieces_locations.append(location)
	purchased_pieces_names.append(piece)
	subtract_coin_amount(piece)
	
func subtract_coin_amount(piece : String):
	current_coin_amount -= coin_amount[piece]

func check_purchasable_tile(tile_pressed : Vector2):
	for tile in purchasable_tiles:
		if tile_pressed == tile:
			return true
	return false
