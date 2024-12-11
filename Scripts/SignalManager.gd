extends Node

signal tile_pressed
signal clear_valid_tiles
signal moved_piece(current_piece : Vector2, next_piece : Vector2)
signal beat_level
signal purchased_piece(piece : String)
signal placed_purchased_piece(location : Vector2, piece : String)
signal complete_purchase
signal next_level_selected
signal done_moving
signal modifier_purchased
signal modifier_placed(location : Vector2)
