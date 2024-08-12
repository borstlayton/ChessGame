extends ColorRect

@onready var piece = $Piece
var ID
var tile_row
var tile_column

func load_icon(piece_name):
	piece.texture = load(BoardManager.assets[piece_name])
func get_icon():
	return piece.texture
func set_icon(new_texture):
	piece.texture = new_texture
func clear_piece():
	piece.texture = null

var num_clicks := 0
		
func set_id(row, column):
	ID = row*8 + column
	tile_row = row
	tile_column = column
func _on_button_button_down():
	BoardManager.show_valid_tiles(tile_row, tile_column)
	SignalManager.tile_pressed.emit()
	
func _on_button_button_up():
	SignalManager.clear_valid_tiles.emit()
#func _on_button_button_up():
	#BoardManager.clear_tiles()
	#num_clicks += 1

func _on_button_pressed():
	if BoardManager.current_board_state == BoardManager.board_states.WHITE_IDLE and get_icon()!= null:
		BoardManager.piece_selected(tile_row, tile_column)
	elif BoardManager.current_board_state == BoardManager.board_states.WHITE_PIECE_CLICKED:
		BoardManager.piece_moved(tile_row, tile_column)
	if BoardManager.current_board_state == BoardManager.board_states.BLACK_IDLE and get_icon()!= null:
		BoardManager.piece_selected(tile_row, tile_column)
	elif BoardManager.current_board_state == BoardManager.board_states.BLACK_PIECE_CLICKED:
		BoardManager.piece_moved(tile_row, tile_column)
	num_clicks += 1
	


