extends Node2D

@onready var knight_bounty_label = $Background/LabelsContainer/KnightBountyLabel
@onready var queen_bounty_label = $Background/LabelsContainer/QueenBountyLabel
@onready var rook_bounty_label = $Background/LabelsContainer/RookBountyLabel
@onready var bishop_bounty_label = $Background/LabelsContainer/BishopBountyLabel
@onready var pawn_bounty_label = $Background/LabelsContainer/PawnBountyLabel

var current_knight_bounty
var current_queen_bounty
var current_rook_bounty
var current_bishop_bounty
var current_pawn_bounty

func _ready():
	update_board()
	
	SignalManager.changed_bounty.connect(update_board)
	
func update_board():
	knight_bounty_label.text = str("knight bounty ", BountyManager.knight_bounty_amount)
	queen_bounty_label.text = str("queen bounty ", BountyManager.queen_bounty_amount)
	rook_bounty_label.text = str("rook bounty ", BountyManager.rook_bounty_amount)
	bishop_bounty_label.text = str("bishop bounty ", BountyManager.bishop_bounty_amount)
	pawn_bounty_label.text = str("pawn bounty ", BountyManager.pawn_bounty_amount)
