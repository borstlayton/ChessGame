class_name Card extends Node2D

@export var card_name : String
@export var card_ID : int
@export var base_cost: int
@export var card_image: Sprite2D

@onready var buy_panel = $BuyPanel
@onready var collision_shape = $Area2D/CollisionShape2D

func _ready():
	buy_panel.hide()
	base_cost = 0
func _on_area_2d_mouse_entered():
	print("entered")


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			buy_panel.show()
			collision_shape.disabled = true

func _on_cancel_button_button_down():
	buy_panel.hide()
	await get_tree().create_timer(0.25).timeout
	collision_shape.disabled = false


func _on_buy_button_button_down():
	if ShopManager.current_coin_amount > base_cost:
		ShopManager.current_coin_amount -= base_cost
		card_effect()
		queue_free()

func card_effect():
	print("put effect here")
