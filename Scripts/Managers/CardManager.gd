extends Node

@onready var card_template = preload("res://Scenes/Cards/CardTemplate.tscn")
@onready var modifier_card_template = preload("res://Scenes/Cards/ModifierCardTemplate.tscn")

@onready var knight_bounty = preload("res://Scenes/Cards/Bounty Cards/KnightBounty.tscn")
@onready var queen_bounty = preload("res://Scenes/Cards/Bounty Cards/QueenBounty.tscn")
@onready var bishop_bounty = preload("res://Scenes/Cards/Bounty Cards/BishopBounty.tscn")
@onready var rook_bounty = preload("res://Scenes/Cards/Bounty Cards/RookBounty.tscn")
@onready var pawn_bounty = preload("res://Scenes/Cards/Bounty Cards/PawnBounty.tscn")

@onready var speed_modifier_card = preload("res://Scenes/Cards/ModifierCards/SpeedModifierCard.tscn")
@onready var balance_modifier_card = preload("res://Scenes/Cards/ModifierCards/BalanceModifierCard.tscn")
@onready var crimson_modifier_card = preload("res://Scenes/Cards/ModifierCards/CrimsonModifierCard.tscn")
@onready var crown_modifier_card = preload("res://Scenes/Cards/ModifierCards/CrownModifierCard.tscn")
@onready var hero_modifier_card = preload("res://Scenes/Cards/ModifierCards/HeroModifierCard.tscn")

var modifier_deck = []
var bounty_deck = []
var permanent_deck = []

func _ready():
	
	bounty_deck.append(queen_bounty)
	bounty_deck.append(knight_bounty)
	bounty_deck.append(bishop_bounty)
	bounty_deck.append(rook_bounty)
	bounty_deck.append(pawn_bounty)
	
	modifier_deck.append(speed_modifier_card)
	modifier_deck.append(balance_modifier_card)
	modifier_deck.append(crimson_modifier_card)
	modifier_deck.append(crown_modifier_card)
	modifier_deck.append(hero_modifier_card)
	
func get_modifier_card():
	return modifier_deck.pick_random().instantiate()

func get_bounty_card():
	return bounty_deck.pick_random().instantiate()
