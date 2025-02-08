extends Control

@onready var sprite = $PieceTaken
@onready var piece_price_label = $PriceLabels/PieceValueLabel
@onready var bounty_value_label = $PriceLabels/BountyValueLabel
@onready var modifier_value_label = $PriceLabels/ModifierValueLabel
@onready var total_piece = $PriceLabels/PieceTotalLabel
func _ready():
	SignalManager.captured_piece.connect(determine_piece)
	SignalManager.done_computing_piece_total.connect(update_text)
	SignalManager.defeated.connect(reset_board)
	
func determine_piece(piece_taken : String, _piece_used : String, _column : int, _row : int, _past_column : int, _past_row : int):
	if piece_taken == piece_taken.to_lower(): #is black piece
		sprite.texture = load(BoardManager.assets[BoardManager.fen_dict[piece_taken]])
		
func update_sprite(updated_sprite : Texture2D):
	sprite.texture = updated_sprite

func update_text(piece_taken : String):
	var piece_value = RoundManager.piece_values[piece_taken]
	var bounty_amount = BountyManager.retreive_bounty(piece_taken)
	var modifier_amount = RoundManager.last_used_modifier_multiplier
	
	piece_price_label.text = str(piece_value)
	bounty_value_label.text = str(bounty_amount)
	modifier_value_label.text = str(modifier_amount)
	total_piece.text = str(int(piece_value * bounty_amount * modifier_amount))

func reset_board():
	piece_price_label.text = ""
	bounty_value_label.text = ""
	modifier_value_label.text = ""
	total_piece.text = ""
	
	sprite.texture = null
