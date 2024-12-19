extends ColorRect

@onready var piece = $Piece
var ID
var tile_row
var tile_column
var modifier_ID
@onready var has_modifier : bool = false
@onready var modifier_scene = preload("res://Scenes/Modifier.tscn")
@onready var modifier_offset = Vector2(80,10)
@onready var new_modifier

func load_icon(piece_name):
	piece.texture = load(BoardManager.assets[piece_name])
func get_icon():
	return piece.texture
func set_icon(new_texture):
	piece.texture = new_texture
func clear_piece():
	piece.texture = null
		
func set_id(row, column):
	ID = row*8 + column
	tile_row = row
	tile_column = column
	
func show_modifier():
	new_modifier = modifier_scene.instantiate()
	new_modifier.position += modifier_offset
	new_modifier.load_icon(ModifierManager.current_purchased_modifier_ID)
	add_child(new_modifier)
	has_modifier = true

func create_modifier(mod_ID : int):
	new_modifier = modifier_scene.instantiate()
	new_modifier.position += modifier_offset
	new_modifier.load_icon(mod_ID)
	new_modifier.set_ID(mod_ID)
	add_child(new_modifier)
	has_modifier = true
	
func check_if_has_modifier():
	return has_modifier

func clear_tile_modifier():
	if has_modifier:
		new_modifier.queue_free()
		has_modifier = false

func get_modifier_ID():
	if has_modifier:
		return new_modifier.modifier_ID
	
func _on_button_button_down():
	if BoardManager.current_board_state == BoardManager.board_states.WHITE_IDLE and BoardManager.current_board[tile_row][tile_column] == BoardManager.current_board[tile_row][tile_column].to_upper():
		BoardManager.show_valid_tiles(tile_row, tile_column)
		SignalManager.tile_pressed.emit()
	elif BoardManager.current_board_state == BoardManager.board_states.BLACK_IDLE and BoardManager.current_board[tile_row][tile_column] == BoardManager.current_board[tile_row][tile_column].to_lower():
		BoardManager.show_valid_tiles(tile_row, tile_column)
		SignalManager.tile_pressed.emit()
		
func _on_button_button_up():
	SignalManager.clear_valid_tiles.emit()

func _on_button_pressed():
	if BoardManager.current_board_state == BoardManager.board_states.WHITE_IDLE and get_icon()!= null:
		BoardManager.piece_selected(tile_row, tile_column)
	elif BoardManager.current_board_state == BoardManager.board_states.WHITE_PIECE_CLICKED:
		BoardManager.piece_moved(tile_row, tile_column)
	
	if BoardManager.current_board_state == BoardManager.board_states.PURCHASE and ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_PIECE:
		if ShopManager.check_purchasable_tile(Vector2(tile_row,tile_column)):
			ShopManager.current_state = ShopManager.piece_purchase_states.PIECE_PLACED
			var location_pressed = Vector2(tile_row, tile_column)
			SignalManager.placed_purchased_piece.emit(location_pressed, ShopManager.current_piece)
			load_icon(BoardManager.fen_dict[ShopManager.current_piece])
			BoardManager.add_to_board(tile_row, tile_column, ShopManager.current_piece)
			SignalManager.complete_purchase.emit()
			ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
			
		elif ShopManager.check_purchasable_tile(Vector2(tile_row,tile_column)) == false:
			ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
			SignalManager.complete_purchase.emit()
			
	if BoardManager.current_board_state == BoardManager.board_states.PURCHASE and ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_MODIFIER:
		if ShopManager.check_modifiable_tile(Vector2(tile_row, tile_column)):
			show_modifier()
			SignalManager.modifier_placed.emit(Vector2(tile_row, tile_column))
			ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
			
		elif ShopManager.check_modifiable_tile(Vector2(tile_row, tile_column)) == false:
			ShopManager.current_state = ShopManager.piece_purchase_states.PURCHASE_IDLE
			SignalManager.modifier_placed.emit(Vector2(tile_row, tile_column))
