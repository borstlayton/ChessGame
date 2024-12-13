extends Node

@onready var card_template = preload("res://Scenes/Cards/CardTemplate.tscn")
@onready var modifier_card_template = preload("res://Scenes/Cards/ModifierCardTemplate.tscn")

@onready var knight_bounty = preload("res://Scenes/Cards/Bounty Cards/KnightBounty.tscn")
@onready var queen_bounty = preload("res://Scenes/Cards/Bounty Cards/QueenBounty.tscn")
@onready var bishop_bounty = preload("res://Scenes/Cards/Bounty Cards/BishopBounty.tscn")
@onready var rook_bounty = preload("res://Scenes/Cards/Bounty Cards/RookBounty.tscn")
@onready var pawn_bounty = preload("res://Scenes/Cards/Bounty Cards/PawnBounty.tscn")



var deck = []

func _ready():
	
	#deck.append(card_template)
	deck.append(modifier_card_template)
	
	#deck.append(queen_bounty)
	#deck.append(knight_bounty)
	#deck.append(bishop_bounty)
	#deck.append(rook_bounty)
	#deck.append(pawn_bounty)
	
func get_card():
	return deck.pick_random().instantiate()
