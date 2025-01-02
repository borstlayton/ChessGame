extends Control

@onready var first_card = $CardContainer/Card1
@onready var second_card = $CardContainer/Card2
@onready var third_card = $CardContainer/Card3
@onready var fourth_card = $CardContainer/Card4

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.beat_level.connect(generate_shop)
	
func generate_shop():
	
	for card_container in [first_card, second_card]:
		card_container.show()
		# Instantiate a new card
		var new_card = CardManager.get_permanent_card()
		# Add the card to the corresponding container
		card_container.add_child(new_card)
		
	for card_container in [third_card, fourth_card]:
		card_container.show()
		# Instantiate a new card
		var new_card = CardManager.get_permanent_card()
		# Add the card to the corresponding container
		card_container.add_child(new_card)


func _on_next_level_button_down():
	pass
#	for card_container in [first_card, second_card, third_card, fourth_card]:
#		if card_container:
#			hide()
