extends Node2D

@onready var tile_scene = preload("res://Scenes/tile.tscn")
@onready var defeat_gui = $ColorRect/Defeat
@onready var grid_container = $ColorRect/GridContainer
@onready var next_level_button = $"ColorRect/Next Level"
@onready var purchase_pieces_gui = $Bottom/GridContainer/PurchasePieces
@onready var purchase_piece_scene = load("res://Scenes/Purchasable Piece.tscn")
@onready var modifier_scene = preload("res://Scenes/Modifier.tscn")
@onready var victory_gui = $ColorRect/Victory
var new_modifier
var has_modifier : bool = false
var purchased_piece
var player_move : bool = true
var alternate_color := Color.BEIGE
func _ready():
	
	SignalManager.tile_pressed.connect(show_valid_grid_tiles)
	SignalManager.clear_valid_tiles.connect(clear_valid_grid_tiles)
	SignalManager.moved_piece.connect(move_piece_grid)
	SignalManager.beat_level.connect(next_level)
	SignalManager.purchased_piece.connect(moving_purchased_piece)
	SignalManager.purchased_piece.connect(show_purchasable_tiles)
	SignalManager.complete_purchase.connect(clear_purchased_piece_scene)
	SignalManager.complete_purchase.connect(check_modifiable)
	SignalManager.modifier_purchased.connect(modifier_moving)
	SignalManager.modifier_placed.connect(check_modifiable)
	SignalManager.captured_piece.connect(piece_captured)
	SignalManager.defeated.connect(reset)
	
	setup_run()
func _process(_delta):
	if ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_PIECE:
		purchased_piece.global_position = get_global_mouse_position()
	
	if ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_MODIFIER and has_modifier:
		new_modifier.global_position = get_global_mouse_position()

func setup_run():
	next_level_button.show()
	purchase_pieces_gui.show()
	defeat_gui.hide()
	victory_gui.hide()
	create_board()
	BoardManager.current_board_state = BoardManager.board_states.PURCHASE
	
func create_board():
	for i in range(8):
		for j in range(8):
			var new_slot = tile_scene.instantiate()
			if (j+i)%2 == 0:
				new_slot.set_color(alternate_color)
			grid_container.add_child(new_slot)
			new_slot.set_id(i,j)
	parse_fen(BoardManager.current_level)
	
func clear_board():
	for i in range(64):
		grid_container.get_child(i).clear_piece()
		if grid_container.get_child(i).check_if_has_modifier():
			grid_container.get_child(i).clear_tile_modifier()
	
	for i in range(BoardManager.board_size):
		for j in range(BoardManager.board_size):
			BoardManager.current_board[i][j] = "0"
			
			
	
func add_piece(num_grid, piece_type):
	var wanted_grid = grid_container.get_child(num_grid)
	wanted_grid.load_icon(piece_type)
	BoardManager.create_board(num_grid, piece_type)
	
func parse_fen(level):
	var fen = FenManager.get_random_fen(FenManager.fen_lower_bounds[level], FenManager.fen_upper_bounds[level])
	#var fen = BoardManager.level_fen[level]
	var boardstate = fen.split(" ")
	var board_index := 0

	for i in boardstate[0]:
		if i == "/":continue
		if i.is_valid_int():
			board_index += i.to_int()
		else:
			add_piece(board_index, BoardManager.fen_dict[i])
			board_index +=1

func show_valid_grid_tiles():
	if BoardManager.current_board_state == BoardManager.board_states.WHITE_IDLE or BoardManager.current_board_state == BoardManager.board_states.BLACK_IDLE:
		grid_container.show_tiles(BoardManager.valid_tiles)
		grid_container.show_current_tile(BoardManager.current_piece)
		
func clear_valid_grid_tiles():
	grid_container.clear_valid_tiles()
func move_piece_grid(current_piece : Vector2, next_piece : Vector2):
	grid_container.move_pieces(current_piece, next_piece)
	
func next_level():
	clear_board()
	BoardManager.current_level += 1
	
	if BoardManager.current_level > 19:
		victory_gui.show()
	
	else:
		next_level_button.show()
		purchase_pieces_gui.show()
		parse_fen(BoardManager.current_level)
		add_piece(60, BoardManager.fen_dict["K"]) #adding king
	
func _on_next_level_button_down():
	BoardManager.turn_counter = 0
	SignalManager.emit_signal("next_level_selected")
	next_level_button.hide()
	purchase_pieces_gui.hide()
	BoardManager.current_board_state = BoardManager.board_states.WHITE_IDLE

func moving_purchased_piece(piece_type):
	var new_piece = purchase_piece_scene.instantiate()
	new_piece.load_icon(BoardManager.fen_dict[piece_type])
	purchased_piece = new_piece
	add_child(purchased_piece)
	ShopManager.current_state = ShopManager.piece_purchase_states.MOVING_PIECE

func _on_cancel_purchase_button_down():
	purchased_piece.queue_free()
	grid_container.clear_valid_tiles()

func clear_purchased_piece_scene():
	purchased_piece.queue_free()

func show_purchasable_tiles(piece_type : String):
	var purchasable_tiles = []
	
	var tile_range_dict := {
		"P": 4,
		"N": 5,
		"B": 5,
		"R": 6,
		"Q": 6
	}
	var row_start : int = tile_range_dict[piece_type]
	for i in range(row_start,8):
		for j in range(8):
			if BoardManager.current_board[i][j] == "0":
				purchasable_tiles.append(Vector2(i,j))
	grid_container.show_tiles(purchasable_tiles)
	ShopManager.purchasable_tiles = purchasable_tiles

func modifier_moving(ID : int):
	next_level_button.hide()
	var modifiable_tiles = []
	for i in range(4,8):
		for j in range(8):
			if BoardManager.current_board[i][j] != "0" and not grid_container.is_tile_modified(Vector2(i,j)):
				modifiable_tiles.append(Vector2(i,j))
	grid_container.show_tiles(modifiable_tiles)
	ShopManager.modifiable_tiles = modifiable_tiles
	ShopManager.current_state = ShopManager.piece_purchase_states.MOVING_MODIFIER
	
	ModifierManager.current_purchased_modifier_ID = ID
	instantiate_modifier(ID)
	
func check_modifiable(_tile : Vector2 = Vector2(-1,-1)):
	var modifiable_tiles_on_board = false
	for i in range(4,8):
		for j in range(8):
			if BoardManager.current_board[i][j] != "0" and not grid_container.is_tile_modified(Vector2(i,j)):
				modifiable_tiles_on_board = true
	ModifierManager.is_modifiable = modifiable_tiles_on_board
	SignalManager.done_checking_modifiable_board.emit()
	
	release_modifier()
	
func instantiate_modifier(ID : int):
	new_modifier = modifier_scene.instantiate()
	new_modifier.load_icon(ID)
	add_child(new_modifier)
	has_modifier = true

func release_modifier():
	if has_modifier:
		new_modifier.queue_free()
		has_modifier = false
	next_level_button.show()
	
func piece_captured(piece_captured : String, piece_used : String, column, row, past_column, past_row):
	var black_piece_used : bool = true if piece_used == piece_used.to_lower() else false
	
	var piece_captured_ID = row*8 + column
	if black_piece_used:
		if(grid_container.get_child(piece_captured_ID).check_if_has_modifier()):
			var modifier_captured_ID = grid_container.get_child(piece_captured_ID).get_modifier_ID()
			ModifierManager.modifier_piece_captured(piece_captured, piece_used, column, row, past_column, past_row, modifier_captured_ID)
			grid_container.get_child(piece_captured_ID).clear_tile_modifier()
			
	elif not black_piece_used:
		if(grid_container.get_child(piece_captured_ID).check_if_has_modifier()):
			var modifier_ID = grid_container.get_child(piece_captured_ID).get_modifier_ID()
			ModifierManager.modifier_piece_used(piece_captured, piece_used, column, row, past_column, past_row, modifier_ID)
		else:
			RoundManager.change_total(piece_captured)

func reset():
	BoardManager.current_board_state = BoardManager.board_states.DEFEATED
	defeat_gui.show()


func _on_reset_button_down() -> void:
	clear_board()
	BoardManager.setup_board()
	ShopManager.current_coin_amount = 50
	setup_run()
	defeat_gui.hide()
