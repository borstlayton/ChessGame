extends Control

@onready var bought_bishop_scene = preload("res://Scenes/Cards/BoughtBountyCards/bought_bishop_bounty.tscn")
@onready var bought_knight_scene = preload("res://Scenes/Cards/BoughtBountyCards/bought_knight_bounty.tscn")
@onready var bought_pawn_scene = preload("res://Scenes/Cards/BoughtBountyCards/bought_pawn_bounty.tscn")
@onready var bought_queen_scene = preload("res://Scenes/Cards/BoughtBountyCards/bought_queen_bounty.tscn")
@onready var bought_rook_scene = preload("res://Scenes/Cards/BoughtBountyCards/bought_rook_bounty.tscn")

@onready var bounty_slot_1 = $CardContainer/BountyCard1
@onready var bounty_slot_2 = $CardContainer/BountyCard2

var bounty_board = [-1,-1]
var bought_bounty_deck = []

func _ready():
	
	bought_bounty_deck.append(bought_bishop_scene)
	bought_bounty_deck.append(bought_knight_scene)
	bought_bounty_deck.append(bought_pawn_scene)
	bought_bounty_deck.append(bought_queen_scene)
	bought_bounty_deck.append(bought_rook_scene)
	
	SignalManager.bought_bounty.connect(update_board)
	SignalManager.beat_level.connect(reset_board)
	
func update_board(cardID : int):
	var slot
	var index
	if bounty_board[0] == -1:
		slot = bounty_slot_1
		index = 0
	else:
		slot = bounty_slot_2
		index = 1
		
	BountyManager.current_bounty_cards[index] = cardID
	bounty_board[index] = cardID
	var new_bought_bounty_scene = bought_bounty_deck[cardID-1].instantiate()
	slot.add_child(new_bought_bounty_scene)

func reset_board():
	if bounty_slot_1.get_child_count() > 0 and bounty_slot_1.get_child(0) != null:
		bounty_slot_1.get_child(0).queue_free()
		
	if bounty_slot_2.get_child_count() > 0 and bounty_slot_2.get_child(0) != null:
		bounty_slot_2.get_child(0).queue_free()
		
	BountyManager.current_bounty_cards = [-1,-1]
	bounty_board = [-1,-1]
