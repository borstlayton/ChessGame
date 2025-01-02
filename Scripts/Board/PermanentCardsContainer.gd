extends GridContainer

var current_card_ID_array = [-1,-1,-1,-1,-1]

var bought_permanent_cards = []
@onready var bought_permanent_card_template = preload("res://Scenes/Cards/BoughtPermanentCards/bought_permanent_card_template.tscn")

func _ready():
	
	bought_permanent_cards.append(bought_permanent_card_template)
	
	SignalManager.bought_permanent_card.connect(update_array)
	
func update_array(ID : int):
	print("update_array ", ID)
	var index = -1
	for i in range(current_card_ID_array.size()):
		if current_card_ID_array[i] == -1:
			index = i
			current_card_ID_array[i] = ID
			break
			
	if index != -1:
		add_card(ID, index)

func add_card(ID : int, index : int):
	var scene = bought_permanent_cards[ID].instantiate()
	get_child(index).add_child(scene)
