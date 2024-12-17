extends Node

@onready var is_modifiable : bool
@onready var current_purchased_modifier_ID : int

var piece_modified : bool
func _ready():
	pass
	
func is_board_modifiable():
	return is_modifiable
	
func modifier_piece_used(piece_captured : String, piece_used : String, column, row, past_column, past_row):
	print(piece_captured)
