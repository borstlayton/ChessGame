extends Node

@onready var knight_scene = preload("res://Scenes/Cards/Bounty Cards/KnightBounty.tscn")
@onready var card_template = preload("res://Scenes/Cards/CardTemplate.tscn")
var deck = []

func ready():
	var knight_scene_instance = knight_scene.instantiate()
	deck.append(knight_scene_instance)
	
	var card_template_instance = card_template.instantiate()
	deck.append(card_template_instance)
	print(deck)
