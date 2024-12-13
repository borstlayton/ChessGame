class_name Card extends Node2D

@export var card_name : String
@export var card_ID : int
@export var base_cost: int = 0
@export var card_image: Sprite2D
@export var summary : String

@onready var buy_panel = $BuyPanel
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var backside = $Backside
@onready var summary_label = $Backside/Summary
@onready var price_label = $Price

func _ready():
	buy_panel.hide()
	base_cost = 0
	
	backside.hide()
	summary = "put summary here"
	summary_label.text = summary
	price_label.text = str(base_cost)

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


func _on_more_info_button_down() -> void:
	backside.show()


func _on_cancel_backside_button_down() -> void:
	backside.hide()
	collision_shape.disabled = true
	await get_tree().create_timer(0.25).timeout
	collision_shape.disabled = false
