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
	if BoardManager.current_board_state == BoardManager.board_states.WHITE_IDLE and BoardManager.current_board[tile_row][tile_column] == BoardManager.current_board[tile_row][tile_column].to_upper():
		BoardManager.show_valid_tiles(tile_row, tile_column)
		SignalManager.tile_pressed.emit()
	elif BoardManager.current_board_state == BoardManager.board_states.BLACK_IDLE and BoardManager.current_board[tile_row][tile_column] == BoardManager.current_board[tile_row][tile_column].to_lower():
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
	
	if BoardManager.current_board_state == BoardManager.board_states.PURCHASE and ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_PIECE:
		if ShopManager.check_purchasable_tile(Vector2(tile_row,tile_column)):
			ShopManager.current_state = ShopManager.piece_purchase_states.PIECE_PLACED
			var location_pressed = Vector2(tile_row, tile_column)
			SignalManager.placed_purchased_piece.emit(location_pressed, ShopManager.current_piece)
			SignalManager.complete_purchase.emit()
			load_icon(BoardManager.fen_dict[ShopManager.current_piece])
			BoardManager.add_to_board(tile_row, tile_column, ShopManager.current_piece)
			ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
		elif ShopManager.check_purchasable_tile(Vector2(tile_row,tile_column)) == false:
			ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
			SignalManager.complete_purchase.emit()
