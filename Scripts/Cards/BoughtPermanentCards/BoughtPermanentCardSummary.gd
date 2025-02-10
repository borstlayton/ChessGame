extends Control

@export var card_name : String
@export var card_summary : String
@export var ID : int

@onready var name_plate = $NamePlateSprite/NamePlate
@onready var summary_label = $SummaryLabel
@onready var current_multiplier_label = $CurrentMultiplier
@onready var card = $".."
func _ready() -> void:
	
	summary_label.text = str(card_summary)
	name_plate.text = str(card_name)
	
	var index = card.index
	BoostsLevel.level_boosts[ID-1][PermanentManager.current_cards_level[index]]
	current_multiplier_label.text = str(BoostsLevel.level_boosts[ID-1][PermanentManager.current_cards_level[index]], "X")
