extends Button

@onready var modifier_scene = preload("res://Scenes/Modifier.tscn")

@onready var new_modifier

func _on_button_down() -> void:
	new_modifier = modifier_scene.instantiate()
	add_child(new_modifier)
	SignalManager.emit_signal("modifier_purchased")
	
	
func _process(delta: float) -> void:
	if ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_MODIFIER:
		new_modifier.global_position = get_global_mouse_position()
