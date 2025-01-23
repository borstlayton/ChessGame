extends Node

@onready var card_template = preload("res://Scenes/Cards/CardTemplate.tscn")
@onready var modifier_card_template = preload("res://Scenes/Cards/ModifierCardTemplate.tscn")
@onready var permanent_card_template = preload("res://Scenes/Cards/PermanentCardTemplate.tscn")

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

@onready var buzzer_beater_card = preload("res://Scenes/Cards/PermanentCards/BuzzerBeaterCard.tscn")
@onready var modless_card = preload("res://Scenes/Cards/PermanentCards/ModlessCard.tscn")
@onready var no_enemies_card = preload("res://Scenes/Cards/PermanentCards/NoEnemiesCard.tscn")
@onready var pawn_promotion_card = preload("res://Scenes/Cards/PermanentCards/PawnPromotionCard.tscn")
@onready var safe_and_sound_card = preload("res://Scenes/Cards/PermanentCards/SafeAndSoundCard.tscn")
@onready var timely_king_card = preload("res://Scenes/Cards/PermanentCards/TimelyKingCard.tscn")

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
	
	permanent_deck.append(buzzer_beater_card)
	permanent_deck.append(modless_card)
#	permanent_deck.append(no_enemies_card)
	permanent_deck.append(pawn_promotion_card)
	permanent_deck.append(safe_and_sound_card)
	permanent_deck.append(timely_king_card)
	
func get_modifier_card():
	return modifier_deck.pick_random().instantiate()

func get_bounty_card():
	return bounty_deck.pick_random().instantiate()

func get_permanent_card():
	return permanent_deck.pick_random().instantiate()
