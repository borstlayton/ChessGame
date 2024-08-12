extends GridContainer

var original_color = Color("b52d00")

func show_tiles(tiles_shown):
	if tiles_shown == null:
		return
	for tile in tiles_shown:
		var ID = 8*tile.x + tile.y
		get_child(ID).set_color(Color.DARK_OLIVE_GREEN)
func show_current_tile(current_piece_tile : Vector2):
	var ID = 8*current_piece_tile.x + current_piece_tile.y
	get_child(ID).set_color(Color.GOLD)
func clear_valid_tiles():
	for i in range(8):
		for j in range(8):
			var current_tile = get_child(8*i+j)
			if (j+i)%2 == 0:
				current_tile.set_color(Color.BEIGE)
			else:
				current_tile.set_color(original_color)
func move_pieces(past_tile : Vector2, next_tile : Vector2):
	var past_ID = past_tile.x * 8 + past_tile.y
	var next_tile_ID = next_tile.x*8 + next_tile.y
	
	get_child(next_tile_ID).set_icon(get_child(past_ID).get_icon())
	get_child(past_ID).clear_piece()
	
	if BoardManager.current_board_state == BoardManager.board_states.WHITE_PIECE_MOVED:
		BoardManager.current_board_state = BoardManager.board_states.BLACK_IDLE
	elif BoardManager.current_board_state == BoardManager.board_states.BLACK_PIECE_MOVED:
		BoardManager.current_board_state = BoardManager.board_states.WHITE_IDLE
