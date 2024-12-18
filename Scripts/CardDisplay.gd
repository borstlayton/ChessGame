extends Control

@onready var first_card = $Card1
@onready var second_card = $Card2
@onready var third_card = $Card3

var knight_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.beat_level.connect(generate_shop)
	
func generate_shop():
	for card_container in [first_card, second_card, third_card]:
		card_container.show()
		# Instantiate a new card
		var new_card = CardManager.get_card()
		# Add the card to the corresponding container
		card_container.add_child(new_card)


func _on_next_level_button_down():
	first_card.hide()
	second_card.hide()
	third_card.hide()
