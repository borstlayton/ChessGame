extends Node

@warning_ignore("unused_signal")
signal tile_pressed
@warning_ignore("unused_signal")
signal clear_valid_tiles
@warning_ignore("unused_signal")
signal moved_piece(current_piece : Vector2, next_piece : Vector2)
@warning_ignore("unused_signal")
signal beat_level
@warning_ignore("unused_signal")
signal purchased_piece(piece : String)
@warning_ignore("unused_signal")
signal placed_purchased_piece(location : Vector2, piece : String)
@warning_ignore("unused_signal")
signal complete_purchase
@warning_ignore("unused_signal")
signal next_level_selected
@warning_ignore("unused_signal")
signal done_moving
@warning_ignore("unused_signal")
signal modifier_purchased(ID : int)
@warning_ignore("unused_signal")
signal modifier_placed(location : Vector2)
@warning_ignore("unused_signal")
signal done_checking_modifiable_board
@warning_ignore("unused_signal")
signal captured_piece(piece_taken : String, piece_used : String, column : int, row : int, past_column : int, past_row : int)
@warning_ignore("unused_signal")
signal turn_change
@warning_ignore("unused_signal")
signal bought_bounty(cardID : int)
@warning_ignore("unused_signal")
signal defeated
@warning_ignore("unused_signal")
signal pawn_promoted(row : int, column : int)
@warning_ignore("unused_signal")
signal bought_permanent_card(ID : int)
@warning_ignore("unused_signal")
signal added_permanent_card
@warning_ignore("unused_signal")
signal card_leveled_up(index : int, new_level : int)
@warning_ignore("unused_signal")
signal done_getting_perma_bonus
@warning_ignore("unused_signal")
signal done_computing_piece_total
