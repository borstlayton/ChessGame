extends GridContainer

var current_card_ID_array = [-1,-1,-1,-1,-1,-1]
var bought_permanent_cards = []

@onready var bought_permanent_card_template = preload("res://Scenes/Cards/BoughtPermanentCards/bought_permanent_card_template.tscn")
@onready var bought_buzzer_beater = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtBuzzerBeater.tscn")
@onready var bought_modless = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtModless.tscn")
@onready var bought_no_enemies = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtNoEnemies.tscn")
@onready var bought_pawn_promotion = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtPawnPromotion.tscn")
@onready var bought_safe_and_sound = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtSafeAndSound.tscn")
@onready var bought_timely_king = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtTimelyKing.tscn")

func _ready():
	
	bought_permanent_cards.append(bought_permanent_card_template)
	bought_permanent_cards.append(bought_buzzer_beater)
	bought_permanent_cards.append(bought_modless)
	bought_permanent_cards.append(bought_no_enemies)
	bought_permanent_cards.append(bought_pawn_promotion)
	bought_permanent_cards.append(bought_safe_and_sound)
	bought_permanent_cards.append(bought_timely_king)
	
	SignalManager.bought_permanent_card.connect(update_array)
	SignalManager.card_leveled_up.connect(update_card_levels)
	SignalManager.deleted_card.connect(delete_card)
	
func update_array(ID : int):
	var index = -1
	for i in range(current_card_ID_array.size()):
		if current_card_ID_array[i] == -1:
			index = i
			current_card_ID_array[i] = ID
			break
			
	if index != -1:
		add_card(ID, index)
		check_availability()
		PermanentManager.current_permanent_cards[index] = ID
		
func add_card(ID : int, index : int):
	var scene = bought_permanent_cards[ID].instantiate()
	scene.set_index(index)
	get_child(index).add_child(scene)
	update_card_levels(index, 0)

func delete_card(index : int):
	current_card_ID_array[index] = -1
func check_availability():
	
	var can_purchase = false
	for i in range(current_card_ID_array.size()):
		if current_card_ID_array[i] == -1:
			can_purchase = true
			
	PermanentManager.slots_available = can_purchase
	SignalManager.added_permanent_card.emit()

func update_card_levels(index : int, level : int):
	get_child(index).get_child(0).update_level_display(level)
