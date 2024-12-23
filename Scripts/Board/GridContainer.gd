extends GridContainer

var original_color = Color("b52d00")

func _ready():
	SignalManager.pawn_promoted.connect(update_icon)
	
#show_tiles
#summary: shows all the valid tiles once called. This is connected to the tile_pressed signal from Board.gd
#iterates through the valid_tiles (or tiles_shown) given for a certain tile then makes them dark olive green 
func show_tiles(tiles_shown):
	if tiles_shown == null:
		return #exits the function if there are no valid tiles
	for tile in tiles_shown:
		var ID = 8*tile.x + tile.y #converts the row and column to the ID of the tile so we can use get_child()
		get_child(ID).set_color(Color.DARK_OLIVE_GREEN)

#show_current_tile
#summary: called when tile_pressed signal from Board.gd. Gets the current piece selected in from the parameters
# and sets it to gold
func show_current_tile(current_piece_tile : Vector2):
	var ID = 8*current_piece_tile.x + current_piece_tile.y #converts the row and column to the ID of the tile so we can use get_child()
	get_child(ID).set_color(Color.GOLD) 

#clear_valid_tiles
#summary: goes through all the tiles in GridContainer (chessboard) and changes all their color to their default
#this is called from tile.gd when the button_up signal is emitted. 
func clear_valid_tiles():
	for i in range(8):
		for j in range(8):
			var current_tile = get_child(8*i+j)
			if (j+i)%2 == 0:
				current_tile.set_color(Color.BEIGE)
			else:
				current_tile.set_color(original_color)
#move_pieces
#summary: takes two parameters of the past_tile and next_tile location. It then converts the ID so that we 
#can use the get_child() function on the grid_container. Next, it sets the next_tile icon to the past_tile icon
#while the past_tile icon is cleared. Finally, it switches the current_board_state to an idle state of the opponent
func move_pieces(past_tile : Vector2, next_tile : Vector2):
	var past_ID = past_tile.x * 8 + past_tile.y
	var next_tile_ID = next_tile.x*8 + next_tile.y
	
	get_child(next_tile_ID).set_icon(get_child(past_ID).get_icon())
	get_child(past_ID).clear_piece()
	
	if get_child(past_ID).check_if_has_modifier():
		get_child(next_tile_ID).create_modifier(get_child(past_ID).get_modifier_ID())
		get_child(past_ID).clear_tile_modifier()

	if BoardManager.current_board_state == BoardManager.board_states.WHITE_PIECE_MOVED:
		BoardManager.current_board_state = BoardManager.board_states.BLACK_IDLE
		SignalManager.emit_signal("done_moving")
	elif BoardManager.current_board_state == BoardManager.board_states.BLACK_PIECE_MOVED:
		BoardManager.current_board_state = BoardManager.board_states.WHITE_IDLE
	
		
func is_tile_modified(tile : Vector2):
	var ID = 8*tile.x + tile.y
	return get_child(ID).check_if_has_modifier()

func update_icon(row : int, column : int):
	var ID = 8*row + column
	get_child(ID).load_icon(BoardManager.fen_dict[BoardManager.current_board[row][column]])
