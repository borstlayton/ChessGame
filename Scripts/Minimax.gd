extends Node2D

var best_move : Vector4 
@export var DEPTH:int = 4

var letters : String = "abcdefgh"

# Called when the node enters the scene tree for the first time.
func _ready():
	best_move = find_best(BoardManager.current_board, BoardManager.turn, DEPTH)

func update_best():
	best_move = find_best(BoardManager.current_board, BoardManager.turn, DEPTH)

func move_to_text(move:Vector4):
	var text : String
	print(move.w)
	text.insert(0,letters[move.w])
	text.insert(1,str(move.x + 1))
	text.insert(2," ")
	text.insert(3,letters[move.y])
	text.insert(4,str(move.z+1))
	return text

var values := { "P" = 1, "p" = -1, 
	"B" = 3, "b" = -3, 
	"N" = 2.9, "n" = -2.9, 
	"R" = 5, "r" = -5, 
	"Q" = 9, "q" = -9, 
	"K" = INF, "k" = -INF,
	"0" = 0,}

func find_best(board:Array[Array], turn:bool, depth:int) -> Vector4:
	var val:float
	var idx:int = 0
	var best_move:Vector4
	var moves = generate_moves(board, turn)
	var children := generate_children(board, moves, turn)
	if turn == true:
		var best_val:float = -INF
		for child_board in children:
			val = _minimax(child_board, depth-1, false, -INF, INF)
			if val > best_val:
				best_val = val
				best_move = moves[idx]
				idx += 1
	else:
		var best_val:float = INF
		for child_board in children:
			val = _minimax(child_board, depth-1, true, -INF, INF)
			best_val = min(val, best_val)
			if val < best_val:
				best_val = val
				best_move = moves[idx]
				idx += 1
	return best_move

func _minimax(board:Array[Array], depth:int, turn:bool, alpha:float, beta:float) -> float:
	if depth == 0:
		return _eval(board)
	if turn == true:
		var best_value := -INF
		var moves = generate_moves(board, turn)
		var children := generate_children(board, moves, turn)
		for child_board in children:
			var value = _minimax(child_board, depth-1, false, alpha, beta)
			best_value = max(best_value, value)
			alpha = max(alpha, best_value)
			if beta <= alpha:
				break
		return best_value
	else:
		var best_value := INF
		var moves = generate_moves(board, turn)
		var children := generate_children(board, moves, turn)
		for child_board in children:
			var value = _minimax(child_board, depth-1, true, alpha, beta)
			best_value = min(best_value, value)
			beta = min(beta, best_value)
			if beta <= alpha:
				break
		return best_value
		
func _eval(board:Array[Array]) -> float:
	var count = 0
	var val
	for row in range(8):
		for column in range(8):
			val = values.board[row][column]
			if val == 1:
				val *= 1.1**row
			elif val == -1:
				val *= 1.1**(7 - row)
			else:
				if row >= 2 and row <= 5:
					val *= 1.05
				if row >= 3 and row <= 4:
					val *= 1.05
				if column >= 2 and column <= 5:
					val *= 1.05
				if column >= 3 and column <= 4:
					val *= 1.05
			count += val
	return count

func generate_children(board:Array[Array], moves:Array[Vector4], turn:bool) -> Array[Array]:
	var children : Array[Array] = []
	var temp : String
	for move in moves:
		#Temp stores what is on the target square
		temp = board[move.y][move.z]
		
		#Move the piece
		board[move.y][move.z] = board[move.w][move.x]
		board[move.w][move.x] = "0"
		
		#Add new board position to children
		children.append(board.duplicate())
		
		#Undo the move
		board[move.w][move.x] = board[move.y][move.z]
		board[move.y][move.z] = temp
	return children

func generate_moves(board:Array[Array], turn : bool) -> Array[Vector4]:
	var possible_moves : Array[Vector4] = [] 
	var curr_piece : Array[Vector2] = [] 
	for row in range(8):
		for column in range(8):
			#The ending locations for the tile
			curr_piece = get_valid_tiles(board, row, column) 
			
			#A move is the starting position (w,x), and the ending position (y,z)
			for loc in curr_piece:
				possible_moves.append(Vector4(row,column,loc.x, loc.y))
			
			#Clear the piece
			curr_piece.clear()
	return possible_moves

func get_valid_tiles(board:Array[Array], row:int, column:int) -> Array[Vector2]:
	var piece : String = board[row][column]
	if piece == "p" || piece == "P":
		return get_pawn_move(board, row, column, piece)
	elif piece == "b" || piece == "B":
		return get_bishop_move(board, row, column, piece)
	elif piece == "n" || piece == "N":
		return get_knight_move(board, row, column, piece)
	elif piece == "r" || piece == "R":
		return get_rook_move(board, row, column, piece)
	elif piece == "q" || piece == "Q":
		return get_queen_move(board, row, column, piece)	
	elif piece == "k" || piece == "K":
		return get_king_move(board, row, column, piece)
	elif piece == "0":
		return []
	else:
		print("ERROR, piece not found")
		return []

func _move(board:Array[Array], row:int, column:int) -> Vector2: 
	if row >= 0 and row <= 7 and column >= 0 and column <= 7:
		if board[row][column] == "0":
			return Vector2(row, column)
		else:
			return Vector2.ZERO
	else:
		return Vector2.ZERO

#Color is the color of the moving piece. 1 if white and 0 if black
func _attack(board:Array[Array], row : int, column : int, piece : bool) -> Vector2:
	#If the square is in bounds
	if row >= 0 and row <= 7 and column >= 0 and column <= 7:
		#Color of the piece on the target square. 1 if white and 0 if black
		var target_color : bool
		if board[row][column] == board[row][column].to_upper():
			target_color = true
		else:
			target_color = false
		#If the square isn't blank and the target color is the oposite of the color of the moving piece, return the square to be added to moves.
		if board[row][column] != "0" and piece != target_color:
			return Vector2(row, column)
		else:
			return Vector2.ZERO
	else: 
		return Vector2.ZERO
		
func check_path(board:Array[Array], direction : Vector2, row : int, column : int,color : bool):
	var legal_moves = []
	var t_row = row + direction.x
	var t_column = column + direction.y
	var continue_direction = true
	var temp : Vector2
	while(continue_direction and t_column >= 0 and t_column < 8 and t_row >= 0 and t_row < 8):
		temp = _move(board, t_row, t_column)
		if temp != Vector2.ZERO:
			legal_moves.append(temp)
		else:
			temp = _attack(board, t_row, t_column, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
			else:
				continue_direction = false
		t_row = t_row + direction.x
		t_column = t_column + direction.y
	return legal_moves

func get_pawn_move(board:Array[Array], row : int, column : int, piece : String) -> Array[Vector2]:
	var legal_moves : Array[Vector2] = []
	var temp
	#If a white piece
	if piece == "P":
		#Move Forward 2
		if row == 1:
			temp = _move(board,row+2,column)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
		#Move Forward
		temp = _move(board,row+1,column)
		if temp != Vector2.ZERO:
			legal_moves.append(temp)  
		#Attack right diagonally
		temp = _attack(board,row+1,column+1, true)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
		#Attack left diagonally
		temp = _attack(board,row+1,column+1, true)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
	elif piece == "p":
		#Move Forward 2
		if row == 6:
			temp = _move(board,row-2,column)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
		#Move Forward
		temp = _move(board,row-1,column)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
		#Attack right diagonally
		temp = _attack(board,row-1,column+1, false)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
		#Attack left diagonally
		temp = _attack(board,row-1,column+1, false)
		if temp != Vector2.ZERO:
			legal_moves.append(temp) 
	return legal_moves
	
func get_bishop_move(board:Array[Array], row : int, column : int, piece : String) -> Array[Vector2]:
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
			new_moves = check_path(board,dir,row,column,color)
			for move in new_moves:
				legal_moves.append(move)
	return legal_moves

func get_knight_move(board:Array[Array], row : int, column : int, piece : String) -> Array[Vector2]:
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
			temp = _move(board,square.x, square.y)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
				continue
			temp = _attack(board,square.x, square.y, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
	return legal_moves
	
	
func get_rook_move(board:Array[Array], row:int, column:int, piece:String) -> Array[Vector2]:
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
			new_moves = check_path(board,dir,row,column,color)
			for move in new_moves:
				legal_moves.append(move)
	return legal_moves
	
func get_queen_move(board:Array[Array], row:int, column:int, piece:String) -> Array[Vector2]:
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
			new_moves = check_path(board,dir,row,column,color)
			for move in new_moves:
				legal_moves.append(move)
	return legal_moves
	
func get_king_move(board:Array[Array], row:int, column:int, piece:String) -> Array[Vector2]:
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
			temp = _move(board,square.x, square.y)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
				continue
			temp = _attack(board,square.x, square.y, color)
			if temp != Vector2.ZERO:
				legal_moves.append(temp)
	return legal_moves

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
