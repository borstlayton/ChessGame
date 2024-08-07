extends Node2D

@onready var tile_scene = preload("res://Scenes/tile.tscn")
@onready var piece_scene = preload("res://Scenes/Piece.tscn")
@onready var grid_container = $ColorRect/GridContainer

var player_move = true
var alternate_color = Color.BEIGE

func _ready():
	
	for i in range(8):
		for j in range(8):
			var new_slot = tile_scene.instantiate()
			if (j+i)%2 == 0:
				new_slot.set_color(alternate_color)
			grid_container.add_child(new_slot)
	parse_fen(BoardManager.current_level)
	
func add_piece(num_grid, piece_type):
	var wanted_grid = grid_container.get_child(num_grid)
	var new_piece = piece_scene.instantiate()
	new_piece.load_icon(piece_type)
	wanted_grid.add_child(new_piece)
	
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
