extends GridContainer

var current_cards = [-1,-1,-1,-1,-1,-1]
var bought_permanent_cards = []
var leveled_up : bool = false

@onready var cards_used_gui = $"../.."
@onready var timer = $Timer

@onready var bought_permanent_card_template = preload("res://Scenes/Cards/BoughtPermanentCards/bought_permanent_card_template.tscn")
@onready var bought_buzzer_beater = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtBuzzerBeater.tscn")
@onready var bought_modless = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtModless.tscn")
@onready var bought_no_enemies = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtNoEnemies.tscn")
@onready var bought_pawn_promotion = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtPawnPromotion.tscn")
@onready var bought_safe_and_sound = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtSafeAndSound.tscn")
@onready var bought_timely_king = preload("res://Scenes/Cards/BoughtPermanentCards/BoughtTimelyKing.tscn")

func _ready():
	
	cards_used_gui.hide()
	
	bought_permanent_cards.append(bought_permanent_card_template)
	bought_permanent_cards.append(bought_buzzer_beater)
	bought_permanent_cards.append(bought_modless)
	bought_permanent_cards.append(bought_no_enemies)
	bought_permanent_cards.append(bought_pawn_promotion)
	bought_permanent_cards.append(bought_safe_and_sound)
	bought_permanent_cards.append(bought_timely_king)
	
	SignalManager.card_leveled_up.connect(append_card)
	SignalManager.beat_level.connect(show_all)
	
func append_card(index: int, level : int):
	
	leveled_up = true
	var ID = PermanentManager.current_permanent_cards[index]
	var scene = bought_permanent_cards[ID].instantiate()
	get_child(index).add_child(scene)
	get_child(index).get_child(0).update_level_display(level)
	
func show_all():
	if leveled_up:
		cards_used_gui.show()
		timer.start()
	
func take_down_gui():
	
	cards_used_gui.hide()
	for i in range(current_cards.size()):
		if current_cards[i] != -1:
			get_child(i).get_child(0).queue_free()
			
	leveled_up = false
	
func _on_timer_timeout() -> void:
	take_down_gui()
