extends Control

@export var card_name : String
@export var card_summary : String

@onready var name_plate = $NamePlate
@onready var summary_label = $SummaryLabel

func _ready() -> void:
	summary_label.text = str(card_summary)
	name_plate.text = str(card_name)
