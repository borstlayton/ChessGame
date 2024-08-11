extends ColorRect

var ID
var tile_row
var tile_column

		
func set_id(row, column):
	ID = row*8 + column
	tile_row = row
	tile_column = column
func _on_button_button_down():
	SignalManager.tile_pressed.emit()
	BoardManager.show_valid_tiles(tile_row, tile_column)
func _on_button_button_up():
	SignalManager.clear_valid_tiles.emit()
func _on_button_pressed():
	if BoardManager.current_board_state == BoardManager.board_states.WHITE_IDLE:
		BoardManager.piece_selected(tile_row, tile_column)
	elif BoardManager.current_board_state == BoardManager.board_states.WHITE_PIECE_CLICKED:
		BoardManager.piece_moved(tile_row, tile_column)
