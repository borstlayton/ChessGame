class_name Card extends Node2D

@export var card_name : String
@export var card_ID : int
@export var base_cost: int = 0
@export var card_image: Sprite2D
@export var summary : String = "put summary here"
@export var card_type : card_types

@onready var buy_panel = $BuyPanel
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var backside = $Backside
@onready var summary_label = $Backside/Summary
@onready var price_label = $CoinLabel/Price
@onready var timer = $Timer
@onready var card_type_label = $Backside/CardTypeLabel
@onready var name_label = $Backside/NamePlate/NameLabel

enum card_types{Bounty, Permanent, Modifier}
var card_map := {
	card_types.Bounty : "Bounty",
	card_types.Permanent : "Permanent",
	card_types.Modifier : "Modifier",
}

var tween_hover : Tween
var can_buy = true
var is_hovered = false
var card_cost
var k = 9
var n = 6

func _ready():
	buy_panel.hide()
	backside.hide()
	
	summary_label.text = summary
	card_type_label.text = card_map[card_type]
	name_label.text = card_name
	SignalManager.beat_level.connect(calculate_price)
	calculate_price()
	
func calculate_price():
	
	card_cost = int((base_cost * (1 + BoardManager.current_level/k) * exp (BoardManager.current_level/n)) + BoardManager.current_level)
	price_label.text = str(card_cost)
	
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


func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
	timer.start()
	
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)


func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	timer.stop()
	backside.hide()
	
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1,1), 0.55)


func _on_timer_timeout() -> void:
	if is_hovered:
		backside.show()
