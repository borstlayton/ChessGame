extends Node

@onready var is_modifiable : bool
@onready var current_purchased_modifier_ID : int

var piece_modified : bool
func _ready():
	pass
	
func is_board_modifiable():
	return is_modifiable
	
func modifier_piece_used(piece_captured : String, piece_used : String, column, row, past_column, past_row, modifier_ID):
	print(modifier_ID)
	
	match modifier_ID:
		0:
			handle_base_modifier()
		1:
			handle_speed_modifier()
		2:
			handle_balance_modifier(piece_captured, piece_used)
		3:
			handle_crimson_modifier()
		4:
			handle_crown_modifier()
		5:
			handle_hero_modifier()
		
	RoundManager.change_total(piece_captured)
	
func handle_base_modifier():
	print("base modifier used")

func handle_speed_modifier():
	if BoardManager.turn_counter <= 10:
		RoundManager.modifier_multiplier = 2
	else:
		RoundManager.modifier_multiplier = 1
		
func handle_balance_modifier(piece_captured : String, piece_used : String):
	var normalized_piece = piece_used.to_lower()
	
	if piece_captured == normalized_piece:
		RoundManager.modifier_multiplier = 2
	else:
		RoundManager.modifier_multiplier = 1
	
	
func handle_crimson_modifier():
	print("crimson modifier used")

func handle_crown_modifier():
	print("crown modifier used")
	
func handle_hero_modifier():
	print("hero modifier used")
