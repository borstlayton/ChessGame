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
signal modifier_purchased(ID : int)
signal modifier_placed(location : Vector2)
signal done_checking_modifiable_board
signal captured_piece(piece_taken : String, piece_used : String, column : int, row : int, past_column : int, past_row : int)
signal turn_change
signal bought_bounty(cardID : int)
signal defeated
signal pawn_promoted(row : int, column : int)
signal bought_permanent_card(ID : int)
signal added_permanent_card
signal card_leveled_up(index : int, new_level : int)
signal done_getting_perma_bonus
signal done_computing_piece_total
signal deleted_card(index : int)
