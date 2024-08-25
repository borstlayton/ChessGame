extends Node

@onready var knight_scene = preload("res://Scenes/Cards/Bounty Cards/KnightBounty.tscn")

var deck = []
func ready():
	var knight_scene_instance = knight_scene.instantiate()
	deck.append(knight_scene_instance)
	print(deck)
