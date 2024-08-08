extends Node

var current_board = []
var current_level
var board_size = 8
var assets := []
enum PieceNames {WHITE_BISHOP, WHITE_KING, WHITE_KNIGHT, WHITE_PAWN, WHITE_QUEEN, WHITE_ROOK, BLACK_BISHOP, BLACK_KING, BLACK_KNIGHT, BLACK_PAWN, BLACK_QUEEN, BLACK_ROOK}
var fen_dict := {	"b" = PieceNames.BLACK_BISHOP, "k" = PieceNames.BLACK_KING, 
					"n" = PieceNames.BLACK_KNIGHT, "p" = PieceNames.BLACK_PAWN, 
					"q" = PieceNames.BLACK_QUEEN, "r" = PieceNames.BLACK_ROOK, 
					"B" = PieceNames.WHITE_BISHOP, "K" = PieceNames.WHITE_KING, 
					"N" = PieceNames.WHITE_KNIGHT, "P" = PieceNames.WHITE_PAWN, 
					"Q" = PieceNames.WHITE_QUEEN, "R" = PieceNames.WHITE_ROOK, }
					
var fen_order = ['b', 'k', 'n', 'p', 'q', 'r', 'B', 'K', 'N', 'P', 'Q', 'R']
var level_fen = {
	0: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",
	1: "rnbqkbnr/pppppppp/pppppppp/8/8/8/PPPPPPPP/RNBQKBNR",
}

func _ready():
	current_level=0
	
	for i in range(board_size):
		var row = []
		for j in range(board_size):
			row.append(0)
		current_board.append(row)

	assets.append("res://Art/Chess Pieces/WhiteBishop.png")
	assets.append("res://Art/Chess Pieces/WhiteKing.png")
	assets.append("res://Art/Chess Pieces/WhiteKnight.png")
	assets.append("res://Art/Chess Pieces/WhitePawn.png")
	assets.append("res://Art/Chess Pieces/WhiteQueen.png")
	assets.append("res://Art/Chess Pieces/WhiteRook.png")
	assets.append("res://Art/Chess Pieces/BlackBishop.png")
	assets.append("res://Art/Chess Pieces/BlackKing.png")
	assets.append("res://Art/Chess Pieces/BlackKnight.png")
	assets.append("res://Art/Chess Pieces/BlackPawn.png")
	assets.append("res://Art/Chess Pieces/BlackQueen.png")
	assets.append("res://Art/Chess Pieces/BlackRook.png")

func create_board(board_index, piece_type):
	var row = int(board_index/8)
	var column = board_index % 8
	
	current_board[row][column] = fen_order[piece_type]

func show_valid_tiles(row, column):
	print("valid", row, column)
