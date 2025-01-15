extends Control

@onready var sprite = $PieceTaken

func _ready():
	SignalManager.captured_piece.connect(determine_piece)
	
func determine_piece(piece_taken : String, _piece_used : String, _column : int, _row : int, _past_column : int, _past_row : int):
	if piece_taken == piece_taken.to_lower(): #is black piece
		sprite.texture = load(BoardManager.assets[BoardManager.fen_dict[piece_taken]])

func update_sprite(updated_sprite : Texture2D):
	sprite.texture = updated_sprite
