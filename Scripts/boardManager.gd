extends Node

var current_board : Array[Array] = []
var current_level : int
var board_size := 8
var assets := []
var valid_tiles = []
var tile_pressed = false
var clear_board = false
enum PieceNames {WHITE_BISHOP, WHITE_KING, WHITE_KNIGHT, WHITE_PAWN, WHITE_QUEEN, WHITE_ROOK, BLACK_BISHOP, BLACK_KING, BLACK_KNIGHT, BLACK_PAWN, BLACK_QUEEN, BLACK_ROOK}
var fen_dict := {	"b" = PieceNames.BLACK_BISHOP, "k" = PieceNames.BLACK_KING, 
					"n" = PieceNames.BLACK_KNIGHT, "p" = PieceNames.BLACK_PAWN, 
					"q" = PieceNames.BLACK_QUEEN, "r" = PieceNames.BLACK_ROOK, 
					"B" = PieceNames.WHITE_BISHOP, "K" = PieceNames.WHITE_KING, 
					"N" = PieceNames.WHITE_KNIGHT, "P" = PieceNames.WHITE_PAWN, 
					"Q" = PieceNames.WHITE_QUEEN, "R" = PieceNames.WHITE_ROOK, }
					
var fen_order : Array[String] = ["b", "k", "n", "p", "q", "r", "B", "K", "N", "P", "Q", "R"]
var level_fen := {
	0: "rnbqkbnr/8/8/8/8/8/PPPPPPPP/RNBQKBNR",
	1: "rnbqkbnr/pppppppp/pppppppp/8/8/8/PPPPPPPP/RNBQKBNR",
}

func _ready():
	current_level = 0
	
	for i in range(board_size):
		var row = []
		for j in range(board_size):
			row.append("0")
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

func create_board(board_index:int, piece_type:int):
	var row := int(board_index/8)
	var column := board_index % 8
	
	current_board[row][column] = fen_order[piece_type]

func show_valid_tiles(row:int, column:int):
	var valid_positions = get_valid_tiles(row,column)

func get_valid_tiles(row:int, column:int):
	var piece : String = current_board[row][column]
	if piece == "p" || piece == "P":
		return get_pawn_move(row, column, piece)
	elif piece == "b" || piece == "B":
		return get_bishop_move(row, column, piece)
	elif piece == "n" || piece == "N":
		return get_knight_move(row, column, piece)
	elif piece == "r" || piece == "R":
		return get_rook_move(row, column, piece)
	elif piece == "q" || piece == "Q":
		return get_queen_move(row, column, piece)	
	elif piece == "k" || piece == "K":
		return get_king_move(row, column, piece)

func _move(row:int, column:int) -> Vector2: 
	if row >= 0 and row <= 7 and column >= 0 and column <= 7:
		if current_board[row][column] == "0":
			return Vector2(row, column)
		else:
			return Vector2.ZERO
	else:
		return Vector2.ZERO

#Color is the color of the moving piece. 1 if white and 0 if black
func _attack(row : int, column : int, piece : bool) -> Vector2:
	#If the square is in bounds
	if row >= 0 and row <= 7 and column >= 0 and column <= 7:
		#Color of the piece on the target square. 1 if white and 0 if black
		var target_color : bool
		if current_board[row][column] == current_board[row][column].to_upper():
			target_color = true
		else:
			target_color = false
		#If the square isn't blank and the target color is the oposite of the color of the moving piece, return the square to be added to moves.
		if current_board[row][column] != "0" and piece != target_color:
			return Vector2(row, column)
		else:
			return Vector2.ZERO
	else: 
		return Vector2.ZERO

func get_pawn_move(row : int, column : int, piece : String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var temp
	#If a white piece
	if piece == "P":
		#Move Forward
		temp = _move(row+1,column)
		if temp != Vector2.ZERO:
			legal_moves.append(temp)  
		#Attack right diagonally
		temp = _attack(row+1,column+1, true)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
		#Attack left diagonally
		temp = _attack(row+1,column+1, true)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
	elif piece == "p":
		#Move Forward
		temp = _move(row-1,column)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
		#Attack right diagonally
		temp = _attack(row-1,column+1, false)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
		#Attack left diagonally
		temp = _attack(row-1,column+1, false)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
	return legal_moves
	
func get_bishop_move(row : int, column : int, piece : String) -> Array[Vector2]:
	print("called bishop")
	var valid_positions : Array[Vector2] = []
	var is_black = piece == piece.to_lower()
	var is_white = piece == piece.to_upper()
	var directions = [
		Vector2(1, 1),
		Vector2(-1, 1), 
		Vector2(1, -1), 
		Vector2(-1, -1) 
	]
	
	for direction in directions:
		var pos = Vector2(column, row) + direction
		while pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8:
			var destination_piece = current_board[pos.y][pos.x]
			if destination_piece == '0':  # Empty square
				valid_positions.append(pos)
			else:
				# Stop if we encounter a piece; add it if it's an opponent's piece
				if (is_black and destination_piece == destination_piece.to_upper()) or (is_white and destination_piece == destination_piece.to_lower()):
					valid_positions.append(pos)
				break  # Bishop cannot move further in this direction
			pos += direction
	print(valid_positions)
	return valid_positions

func get_knight_move(row : int, column : int, piece : String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var possible_attacks : Array[Vector2] = [Vector2(row-2,column+1), Vector2(row-1,column+2), Vector2(row+1,column+2), Vector2(row+2,column+1), Vector2(row+2,column-1), Vector2(row+1,column-2), Vector2(row-1,column-2), Vector2(row-2,column-1)]
	var color : bool
	if piece == piece.to_upper():
		color = true
	else:
		color = false
	var temp : Vector2
	#If a Knight
	if piece == "N" || piece == "n":
		for square in possible_attacks:
			temp = _attack(square.x, square.y, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
	return legal_moves
	
	
func get_rook_move(row:int, column:int, piece:String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var directions : Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	var color : bool
	if piece == piece.to_upper():
		color = true
	else:
		color = false
	var temp : Vector2
	#If a rook
	if piece == "R" || piece == "r":
		for dir in directions:
			var t_row = row + dir.x
			var t_column = column + dir.y
			while(true):
				temp = _attack(t_row, t_column, color)
				if temp != Vector2.ZERO:
					legal_moves.append(temp)
					t_row += dir.x
					t_column += dir.y	
				else:
					break
	return legal_moves
	
func get_queen_move(row:int, column:int, piece:String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2(1,1), Vector2(-1,1), Vector2(-1,-1), Vector2(1,-1)]
	var color : bool
	if piece == piece.to_upper():
		color = true
	else:
		color = false
	var temp : Vector2
	#If a queen
	if piece == "Q" || piece == "q":
		for dir in directions:
			var t_row = row + dir.x
			var t_column = column + dir.y
			while(true):
				temp = _attack(t_row, t_column, color)
				if temp != Vector2.ZERO:
					legal_moves.append(temp)
					t_row += dir.x
					t_column += dir.y	
				else:
					break
	return legal_moves
	
func get_king_move(row:int, column:int, piece:String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var possible_attacks = [Vector2(row-1,column-1), Vector2(row-1,column), Vector2(row-1,column+1), Vector2(row,column-1), Vector2(row,column+1), Vector2(row+1,column-1), Vector2(row+1,column), Vector2(row+1,column+1)]
	var color : bool
	if piece == piece.to_upper():
		color = true
	else:
		color = false
	var temp : Vector2
	#If a white piece
	if piece == "K" || piece == "k":
		for square in possible_attacks:
			temp = _attack(square.x, square.y, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
	return legal_moves
	
