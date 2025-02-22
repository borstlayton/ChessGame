class_name BoughtPermanentCard extends Node2D

@onready var level_label = $LevelDisplay/Label
@onready var sell_menu = $SellMenu
@onready var timer = $Timer
@onready var summary_panel = $Summary

var is_hovered : bool = false
var tween_hover : Tween
var index : int

func _ready():
	sell_menu.hide()
	summary_panel.hide()
	
	SignalManager.defeated.connect(_on_delete_button_pressed)
	
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
	summary_panel.hide()
	
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1,1), 0.55)

func update_level_display(level : int):
	level_label.text = str("Lvl ", level+1)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		sell_menu.show()

func set_index(ind : int):
	index = ind
	
func _on_delete_button_pressed() -> void:
	self.queue_free()
	SignalManager.deleted_card.emit(index)
	
func _on_cancel_button_pressed() -> void:
	sell_menu.hide()


func _on_timer_timeout() -> void:
	if is_hovered:
		summary_panel.show()
