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
@onready var price_label = $CoinLabel/Price

var tween_hover : Tween
var can_buy = true

func _ready():
	buy_panel.hide()
	base_cost = 0
	
	backside.hide()
	summary = "put summary here"
	summary_label.text = summary
	price_label.text = str(base_cost)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and can_buy:
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


func _on_area_2d_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)


func _on_area_2d_mouse_exited() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1,1), 0.55)
