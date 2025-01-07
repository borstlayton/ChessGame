extends Node

var slots_available
var current_permanent_cards = [-1,-1,-1,-1,-1,-1]
var current_cards_level = [1,1,1,1,1,1]

var buzzer_beater : bool = false
var modless : bool = true
var safe_and_sound : bool = true
var pawn_promotion : bool = false
var timely_king : bool = false
var no_enemies : bool = true

func _ready():
	slots_available = true
	
	SignalManager.captured_piece.connect(piece_captured_boosts)
	SignalManager.modifier_placed.connect(modifier_boosts)
	SignalManager.pawn_promoted.connect(pawn_promotion_boosts)
	SignalManager.beat_level.connect(traverse_cards)
	SignalManager.next_level_selected.connect(reset_bools)
	
func reset_bools():
	
	buzzer_beater= false
	modless = true
	safe_and_sound = true
	pawn_promotion = false
	timely_king = false
	no_enemies = true

func piece_captured_boosts(piece_captured : String, _piece_used : String, _column, _row, _past_column, _past_row):
	#buzzer_beater
	if piece_captured == "k" and BoardManager.turn_counter == (BoardManager.turns_per_level[BoardManager.current_level]-1):
		buzzer_beater = true
	#timely_king
	if piece_captured == "k" and BoardManager.turn_counter <= (BoardManager.turns_per_level[BoardManager.current_level]/2):
		timely_king = true
	#safe_and_sound
	if piece_captured == piece_captured.to_upper():
		safe_and_sound = false
	#no_enemies
	elif piece_captured == piece_captured.to_lower():
		no_enemies = false
func modifier_boosts(location : Vector2):
	#modless
	modless = false

func pawn_promotion_boosts(_row : int, _column : int):
	pawn_promotion = true

func traverse_cards():
	for i in range(current_permanent_cards.size()):
		var card = current_permanent_cards[i]
		var used : bool = false
		match card:
			-1:
				continue
			1:
				used = buzzer_beater
			2:
				used = modless
			3:
				used = no_enemies
			4:
				used = pawn_promotion
			5:
				used = safe_and_sound
			6:
				used = timely_king
		
		if used:
			current_cards_level[i] += 1
			SignalManager.card_leveled_up.emit(i, current_cards_level[i])
