extends Node

var my_csharp_script = load("res://Scripts/Board/ChessAi.cs")
var my_csharp_node = my_csharp_script.new()

var current_board : Array[Array] = []
var turn:bool = true
var current_level : int
var board_size := 8
var assets := []
var valid_tiles = []
var current_board_state = board_states.PURCHASE
var current_piece : Vector2
var turn_counter : int = 0

enum board_states {WHITE_IDLE,WHITE_PIECE_CLICKED, WHITE_PIECE_MOVED, BLACK_IDLE, BLACK_PIECE_CLICKED, BLACK_PIECE_MOVED, PURCHASE, DEFEATED}
var tile_pressed = false
var clear_board = false

enum PieceNames {BLACK_BISHOP, BLACK_KING, BLACK_KNIGHT, BLACK_PAWN, BLACK_QUEEN, BLACK_ROOK, WHITE_BISHOP, WHITE_KING, WHITE_KNIGHT, WHITE_PAWN, WHITE_QUEEN, WHITE_ROOK}
var fen_dict := {	"b" = PieceNames.BLACK_BISHOP, "k" = PieceNames.BLACK_KING, 
					"n" = PieceNames.BLACK_KNIGHT, "p" = PieceNames.BLACK_PAWN, 
					"q" = PieceNames.BLACK_QUEEN, "r" = PieceNames.BLACK_ROOK, 
					"B" = PieceNames.WHITE_BISHOP, "K" = PieceNames.WHITE_KING, 
					"N" = PieceNames.WHITE_KNIGHT, "P" = PieceNames.WHITE_PAWN, 
					"Q" = PieceNames.WHITE_QUEEN, "R" = PieceNames.WHITE_ROOK, }
					
var fen_order : Array[String] = ["b", "k", "n", "p", "q", "r", "B", "K", "N", "P", "Q", "R"]
var level_fen := {
	0: "1111k111/111ppp11/8/8/8/8/8/1111K111",
	1: "111nkn11/111ppp11/8/8/8/8/8/1111K111",
	2: "111qknn1/111ppp11/8/8/8/8/8/4K3",
	3: "1rbqkn11/11pppp11/8/8/8/8/8/4K3",
	4: "11prkrn1/8/111pp111/8/8/8/8/4K3",
	5: "1111k111/111ppp11/8/8/8/8/8/1111K111",
	6: "1111k111/111ppp11/8/8/8/8/8/1111K111",
	7: "1111k111/111ppp11/8/8/8/8/8/1111K111",
	8: "1111k111/111ppp11/8/8/8/8/8/1111K111",
	9: "1111k111/111ppp11/8/8/8/8/8/1111K111",
	10: "1111k111/111ppp11/8/8/8/8/8/1111K111"
}
var turns_per_level := {
	0: 10,
	1: 15,
	2: 15,
	3: 20,
	4: 25,
	5: 25,
	6: 30,
	7: 30,
	8: 35,
	9: 35,
	10: 35
}
func _ready():
	setup_board()
	
	assets.append("res://Art/Chess Pieces/BlackBishop.png")
	assets.append("res://Art/Chess Pieces/BlackKing.png")
	assets.append("res://Art/Chess Pieces/BlackKnight.png")
	assets.append("res://Art/Chess Pieces/BlackPawn.png")
	assets.append("res://Art/Chess Pieces/BlackQueen.png")
	assets.append("res://Art/Chess Pieces/BlackRook.png")
	assets.append("res://Art/Chess Pieces/WhiteBishop.png")
	assets.append("res://Art/Chess Pieces/WhiteKing.png")
	assets.append("res://Art/Chess Pieces/WhiteKnight.png")
	assets.append("res://Art/Chess Pieces/WhitePawn.png")
	assets.append("res://Art/Chess Pieces/WhiteQueen.png")
	assets.append("res://Art/Chess Pieces/WhiteRook.png")
	
	SignalManager.done_moving.connect(get_ai_move)

func setup_board():
	current_level = 0
	for i in range(board_size):
		var row = []
		for j in range(board_size):
			row.append("0")
		current_board.append(row)

func get_board():
	return current_board
	
#piece_selected_selected
#summary: checks if either side is in the IDLE state and sets the current_piece to the piece selected
#returns nothing, sets the board state to PIECE_CLICKED and the current_piece to the piece they have selected
func piece_selected(row : int, column : int):
	#check if in IDLE and a white piece
	if current_board[row][column] != "0" and current_board_state == board_states.WHITE_IDLE and current_board[row][column] == current_board[row][column].to_upper():
		valid_tiles = get_valid_tiles(row, column)
		current_board_state = board_states.WHITE_PIECE_CLICKED
		current_piece = Vector2(row,column)
	#check if in IDLE and a black piece
	elif current_board[row][column] != "0" and current_board_state == board_states.BLACK_IDLE and current_board[row][column] == current_board[row][column].to_lower():
		valid_tiles = get_valid_tiles(row, column)
		current_board_state = board_states.BLACK_PIECE_CLICKED
		current_piece = Vector2(row,column)
		
#piece_moved
#summary: takes in the arguments of where the next click is after being in PIECE_CLICKED state
#checks if the tile clicked is in the valid_tiles, and if it is, it moves the piece there
#if not, it switches back to the IDLE state and waits for your next click to choose the next current_piece
func piece_moved(row: int, column : int):
	var is_valid_tile : bool
	for tile in valid_tiles: #looks through all the tiles to see if the tile clicked matches with one of the valid tiles
		if tile == Vector2(row,column):
			is_valid_tile = true
			break
	if is_valid_tile:
		move_pieces(row,column) #moves the pieces
	else:
		if current_board_state == board_states.WHITE_PIECE_CLICKED:
			current_board_state = board_states.WHITE_IDLE
		elif current_board_state == board_states.BLACK_PIECE_CLICKED:
			current_board_state = board_states.BLACK_IDLE
#move_pieces
#summary: is called after the current_board_state is PIECE_CLICKED and another tile that is in valid
#tiles is clicked. It moves the pieces on the current board after changing the current_board_state
#to PIECE_MOVED
func move_pieces(row : int, column : int):
	
	var white_turn : bool = false
	
	if current_board_state == board_states.WHITE_PIECE_CLICKED:
		white_turn = true
		current_board_state = board_states.WHITE_PIECE_MOVED
		
	elif current_board_state == board_states.BLACK_PIECE_CLICKED:
		white_turn = false
		current_board_state = board_states.BLACK_PIECE_MOVED
	
	var past_piece = current_board[row][column]
	var moving_piece = current_board[current_piece.x][current_piece.y]
	
	current_board[row][column] = current_board[current_piece.x][current_piece.y]
	current_board[current_piece.x][current_piece.y] = "0"
	
	SignalManager.moved_piece.emit(current_piece, Vector2(row,column))
	
	if past_piece != "0":
		SignalManager.captured_piece.emit(past_piece, current_board[row][column], column, row, current_piece.y, current_piece.x)
	
	if white_turn:
		change_turn()
	
	check_king_capture(past_piece)
	check_promotion(moving_piece, row, column)

func check_king_capture(past_piece : String):
		if past_piece == "k":
			current_board_state = board_states.PURCHASE
			SignalManager.beat_level.emit()
		elif past_piece == "K":
			SignalManager.defeated.emit()
			
func change_turn():
	
	turn_counter += 1
	if turn_counter > turns_per_level[current_level]:
		turn_counter = 0
		current_board_state = board_states.PURCHASE
		SignalManager.beat_level.emit()
	SignalManager.turn_change.emit()

func check_promotion(piece_moved : String, row : int, column : int):
	
	if piece_moved == "p" and row == 7:
		current_board[row][column] = "q"
		SignalManager.pawn_promoted.emit(row, column)
	elif piece_moved == "P" and row == 0:
		current_board[row][column] = "Q"
		SignalManager.pawn_promoted.emit(row, column)
	
func create_board(board_index:int, piece_type:int):
	var row := int(board_index/8)
	var column := board_index % 8
	
	current_board[row][column] = fen_order[piece_type]

func add_to_board(row : int, column : int, piece : String):
	current_board[row][column] = piece
	
func show_valid_tiles(row: int, column:int):
	if current_board[row][column] != "0":
		current_piece = Vector2(row,column)
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
			return Vector2(-1,-1)
	else:
		return Vector2(-1,-1)

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
			return Vector2(-1,-1)
	else: 
		return Vector2(-1,-1)
		
func check_path(direction : Vector2, row : int, column : int,color : bool):
	
	var legal_moves = []
	var t_row = row + direction.x
	var t_column = column + direction.y
	var continue_direction = true
	var temp : Vector2
	while(continue_direction and t_column >= 0 and t_column < 8 and t_row >= 0 and t_row < 8):
		temp = _move(t_row, t_column)
		if temp != Vector2(-1,-1):
			legal_moves.append(temp)
		else:
			temp = _attack(t_row, t_column, color)
			if temp != Vector2(-1,-1):
				legal_moves.append(temp)
			continue_direction = false
		t_row = t_row + direction.x
		t_column = t_column + direction.y
	return legal_moves

func get_pawn_move(row: int, column: int, piece: String) -> Array[Vector2]:
	var legal_moves: Array[Vector2] = []
	var temp: Vector2
	var temp2: Vector2

	if piece == "P": # White Pawn
		# Move forward one step
		temp = _move(row - 1, column)
		if temp != Vector2(-1, -1):
			legal_moves.append(temp)
			
			# Move forward two steps if on the starting row
			if row == 6:
				temp2 = _move(row - 2, column)
				if temp2 != Vector2(-1, -1):
					legal_moves.append(temp2)
		
		# Capture diagonally to the right
		temp = _attack(row - 1, column + 1, true)
		if temp != Vector2(-1, -1):
			legal_moves.append(temp)
		
		# Capture diagonally to the left
		temp = _attack(row - 1, column - 1, true)
		if temp != Vector2(-1, -1):
			legal_moves.append(temp)
	
	elif piece == "p": # Black Pawn
		# Move forward one step
		temp = _move(row + 1, column)
		if temp != Vector2(-1, -1):
			legal_moves.append(temp)
			
			# Move forward two steps if on the starting row
			if row == 1:
				temp2 = _move(row + 2, column)
				if temp2 != Vector2(-1, -1):
					legal_moves.append(temp2)
		
		# Capture diagonally to the right
		temp = _attack(row + 1, column + 1, false)
		if temp != Vector2(-1, -1):
			legal_moves.append(temp)
		
		# Capture diagonally to the left
		temp = _attack(row + 1, column - 1, false)
		if temp != Vector2(-1, -1):
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
			if temp != Vector2(-1,-1):
				legal_moves.append(temp)
				continue
			temp = _attack(square.x, square.y, color)
			if temp != Vector2(-1,-1):
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
			if temp != Vector2(-1,-1):
				legal_moves.append(temp)
				continue
			temp = _attack(square.x, square.y, color)
			if temp != Vector2(-1,-1):
				legal_moves.append(temp)
	return legal_moves
	
func get_ai_move():
	var flattened_board : Array = []
	for row in current_board:
		for cell in row:
			flattened_board.append(cell)
	await get_tree().create_timer(0.25).timeout
	var best_move = my_csharp_node.get_best_move(flattened_board)
	
	piece_selected(int(best_move.substr(0,1)), int(best_move.substr(1,1)))
	piece_moved(int(best_move.substr(2,1)), int(best_move.substr(3,1)))
