extends Node2D

@onready var tile_scene = preload("res://Scenes/tile.tscn")
@onready var grid_container = $ColorRect/GridContainer
@onready var next_level_button = $"Control/Next Level"
@onready var best_move = $Control/BestMove
@onready var minimax = $Minimax

var player_move : bool = true
var alternate_color := Color.BEIGE
func _ready():
	
	next_level_button.hide()
	purchase_pieces_gui.hide()
	
	SignalManager.tile_pressed.connect(show_valid_grid_tiles)
	SignalManager.clear_valid_tiles.connect(clear_valid_grid_tiles)
	SignalManager.moved_piece.connect(move_piece_grid)
	SignalManager.beat_level.connect(next_level)
	
	best_move.text = "Best Move:" + minimax.move_to_text(minimax.current_best())
	
	create_board()
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
	next_level_button.hide()
	purchase_pieces_gui.hide()
	parse_fen(BoardManager.current_level)
	BoardManager.current_board_state = BoardManager.board_states.WHITE_IDLE

func _on_best_move_button_pressed():
	best_move.text = "Best Move:" + minimax.move_to_text(minimax.current_best())
	print("Update Complete")
