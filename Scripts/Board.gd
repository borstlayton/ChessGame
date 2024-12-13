extends Node2D

@onready var tile_scene = preload("res://Scenes/tile.tscn")
@onready var grid_container = $ColorRect/GridContainer
@onready var next_level_button = $"Control/Next Level"
@onready var purchase_pieces_gui = $Control/PurchasePieces
@onready var purchase_piece_scene = load("res://Scenes/Purchasable Piece.tscn")
@onready var modifier_scene = preload("res://Scenes/Modifier.tscn")

@onready var new_modifier
@onready var has_modifier : bool = false
var purchased_piece
var player_move : bool = true
var alternate_color := Color.BEIGE
func _ready():
	
	next_level_button.hide()
	purchase_pieces_gui.hide()
	
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
	
	create_board()
	
func _process(delta):
	if ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_PIECE:
		purchased_piece.global_position = get_global_mouse_position()
	
	if ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_MODIFIER and has_modifier:
		new_modifier.global_position = get_global_mouse_position()
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
		
func add_piece(num_grid, piece_type):
	var wanted_grid = grid_container.get_child(num_grid)
	wanted_grid.load_icon(piece_type)
	BoardManager.create_board(num_grid, piece_type)
	
func parse_fen(level):
	var fen = BoardManager.level_fen[level]
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
	next_level_button.show()
	purchase_pieces_gui.show()
	
func _on_next_level_button_down():
	SignalManager.emit_signal("next_level_selected")
	next_level_button.hide()
	purchase_pieces_gui.hide()
	parse_fen(BoardManager.current_level)
	BoardManager.current_board_state = BoardManager.board_states.WHITE_IDLE

func moving_purchased_piece(piece_type):
	var new_piece = purchase_piece_scene.instantiate()
	new_piece.load_icon(BoardManager.fen_dict[piece_type])
	purchased_piece = new_piece
	add_child(purchased_piece)
	ShopManager.current_state = ShopManager.piece_purchase_states.MOVING_PIECE

func _on_cancel_purchase_button_down():
	purchased_piece.queue_free()
	print("Best Move Update Complete")

func clear_purchased_piece_scene():
	purchased_piece.queue_free()

func show_purchasable_tiles(_piece_type : String):
	var purchasable_tiles = []
	for i in range(6,8):
		for j in range(8):
			if BoardManager.current_board[i][j] == "0":
				purchasable_tiles.append(Vector2(i,j))
	grid_container.show_tiles(purchasable_tiles)
	ShopManager.purchasable_tiles = purchasable_tiles

func modifier_moving():
	var modifiable_tiles = []
	for i in range(6,8):
		for j in range(8):
			if BoardManager.current_board[i][j] != "0" and not grid_container.is_tile_modified(Vector2(i,j)):
				modifiable_tiles.append(Vector2(i,j))
	grid_container.show_tiles(modifiable_tiles)
	ShopManager.modifiable_tiles = modifiable_tiles
	ShopManager.current_state = ShopManager.piece_purchase_states.MOVING_MODIFIER
	
	instantiate_modifier()
	
func check_modifiable(_tile : Vector2 = Vector2(-1,-1)):
	var modifiable_tiles_on_board = false
	for i in range(6,8):
		for j in range(8):
			if BoardManager.current_board[i][j] != "0" and not grid_container.is_tile_modified(Vector2(i,j)):
				modifiable_tiles_on_board = true
				
	ModifierManager.is_modifiable = modifiable_tiles_on_board
	SignalManager.done_checking_modifiable_board.emit()
	
	release_modifier()
	
func instantiate_modifier():
	new_modifier = modifier_scene.instantiate()
	add_child(new_modifier)
	has_modifier = true

func release_modifier():
	if has_modifier:
		new_modifier.queue_free()
		has_modifier = false
