extends Control

@onready var first_card = $Card1
@onready var second_card = $Card2
@onready var third_card = $Card3


var knight_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.beat_level.connect(generate_shop)
func generate_shop():
	knight_scene = CardManager.knight_scene.instantiate()
	first_card.add_child(knight_scene)
	knight_scene = CardManager.knight_scene.instantiate()
	second_card.add_child(knight_scene)
	knight_scene = CardManager.knight_scene.instantiate()
	third_card.add_child(knight_scene)


func _on_next_level_button_down():
	first_card.queue_free()
	second_card.queue_free()
	third_card.queue_free()
