extends Node

@onready var knight_scene = preload("res://Scenes/Cards/Bounty Cards/KnightBounty.tscn")
@onready var card_template = preload("res://Scenes/Cards/CardTemplate.tscn")
var deck = []

func _ready():
	var knight_scene_instance = knight_scene
	deck.append(knight_scene)
	
	var card_template_instance = card_template
	deck.append(card_template)

func get_card():
	return deck.pick_random().instantiate()
