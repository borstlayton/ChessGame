extends Node

var current_board : Array[Array] = []
var current_level : int
var board_size := 8
var assets := []
var valid_tiles = []
var current_board_state = board_states.WHITE_IDLE
var current_piece : Vector2

enum board_states {WHITE_IDLE,WHITE_PIECE_CLICKED, WHITE_PIECE_MOVED, BLACK_IDLE, BLACK_PIECE_CLICKED, BLACK_PIECE_MOVED}
enum PieceNames {WHITE_BISHOP, WHITE_KING, WHITE_KNIGHT, WHITE_PAWN, WHITE_QUEEN, WHITE_ROOK, BLACK_BISHOP, BLACK_KING, BLACK_KNIGHT, BLACK_PAWN, BLACK_QUEEN, BLACK_ROOK}
var fen_dict := {	"b" = PieceNames.BLACK_BISHOP, "k" = PieceNames.BLACK_KING, 
					"n" = PieceNames.BLACK_KNIGHT, "p" = PieceNames.BLACK_PAWN, 
					"q" = PieceNames.BLACK_QUEEN, "r" = PieceNames.BLACK_ROOK, 
					"B" = PieceNames.WHITE_BISHOP, "K" = PieceNames.WHITE_KING, 
					"N" = PieceNames.WHITE_KNIGHT, "P" = PieceNames.WHITE_PAWN, 
					"Q" = PieceNames.WHITE_QUEEN, "R" = PieceNames.WHITE_ROOK, }
					
var fen_order : Array[String] = ["b", "k", "n", "p", "q", "r", "B", "K", "N", "P", "Q", "R"]
var level_fen := {
	0: "rnbqkbnr/pppp4/8/8/8/8/8/RNBQKBNR",
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

func piece_selected(row : int, column : int):
	if current_board_state == board_states.WHITE_IDLE and current_board[row][column] == current_board[row][column].to_upper():
		valid_tiles = get_valid_tiles(row, column)
		current_board_state = board_states.WHITE_PIECE_CLICKED
		current_piece = Vector2(row,column)
		
func piece_moved(row: int, column : int):
	var is_valid_tile : bool
	for tile in valid_tiles:
		if tile == Vector2(row,column):
			is_valid_tile = true
			break
	if is_valid_tile:
		move_pieces(row,column)
	else:
		current_piece = Vector2(-1,-1)
		current_board_state = board_states.WHITE_IDLE
func move_pieces(row : int, column : int):

	current_board[row][column] = current_board[current_piece.x][current_piece.y]
	current_board[current_piece.x][current_piece.y] = "0"
	print(current_board)
func create_board(board_index:int, piece_type:int):
	var row := int(board_index/8)
	var column := board_index % 8
	
	current_board[row][column] = fen_order[piece_type]

func show_valid_tiles(row: int, column:int):
	if current_board[row][column] != "0":
		valid_tiles = get_valid_tiles(row,column)

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
		
func check_path(direction : Vector2, row : int, column : int,color : bool):
	
	var legal_moves = []
	var t_row = row + direction.x
	var t_column = column + direction.y
	var continue_direction = true
	var temp : Vector2
	while(continue_direction and t_column >= 0 and t_column < 8 and t_row >= 0 and t_row < 8):
		temp = _move(t_row, t_column)
		if temp != Vector2.ZERO:
			legal_moves.append(temp)
		else:
			temp = _attack(t_row, t_column, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
			else:
				continue_direction = false
		t_row = t_row + direction.x
		t_column = t_column + direction.y
	return legal_moves

func get_pawn_move(row : int, column : int, piece : String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var temp
	#If a white piece
	if piece == "P":
		#Move Forward 2
		if row == 1:
			temp = _move(row+2,column)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
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
		#Move Forward 2
		if row == 6:
			temp = _move(row-2,column)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
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
	var legal_moves : Array[Vector2] = []
	var new_moves : Array = []
	var directions = [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1) 
	]
	var color : bool
	if piece == piece.to_upper():
		color = true
	else:
		color = false
	#If a bishop
	if piece == "B" || piece == "b":
		for dir in directions:
			new_moves = check_path(dir,row,column,color)
			for move in new_moves:
				legal_moves.append(move)
	return legal_moves

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
			temp = _move(square.x, square.y)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
				continue
			temp = _attack(square.x, square.y, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
	return legal_moves
	
	
func get_rook_move(row:int, column:int, piece:String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var new_moves : Array = []
	var directions : Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	var color : bool
	if piece == piece.to_upper():
		color = true
	else:
		color = false
	#If a rook
	if piece == "R" || piece == "r":
		for dir in directions:
			new_moves = check_path(dir,row,column,color)
			for move in new_moves:
				legal_moves.append(move)
	return legal_moves
	
func get_queen_move(row:int, column:int, piece:String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var new_moves : Array = []
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2(1,1), Vector2(-1,1), Vector2(-1,-1), Vector2(1,-1)]
	var color : bool
	if piece == piece.to_upper():
		color = true
	else:
		color = false
	#If a queen
	if piece == "Q" || piece == "q":
		for dir in directions:
			new_moves = check_path(dir,row,column,color)
			for move in new_moves:
				legal_moves.append(move)
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
			temp = _move(square.x, square.y)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
				continue
			temp = _attack(square.x, square.y, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
	return legal_moves
	
