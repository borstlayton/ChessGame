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
	knight_bounty_label.text = str("knight bounty 1x")
	queen_bounty_label.text = str("queen bounty 1x")
	rook_bounty_label.text = str("rook bounty 1x")
	bishop_bounty_label.text = str("bishop bounty 1x")
	pawn_bounty_label.text = str("pawn bounty 1x")
