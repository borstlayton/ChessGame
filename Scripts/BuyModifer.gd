extends Button

@onready var modifier_scene = preload("res://Scenes/Modifier.tscn")

@onready var new_modifier
@onready var has_modifier : bool = false
func _ready():
	SignalManager.modifier_placed.connect(release_modifier)
	
func _on_button_down() -> void:
	new_modifier = modifier_scene.instantiate()
	add_child(new_modifier)
	SignalManager.emit_signal("modifier_purchased")
	has_modifier = true
	
func _process(delta: float) -> void:
	if ShopManager.current_state == ShopManager.piece_purchase_states.MOVING_MODIFIER and has_modifier:
		new_modifier.global_position = get_global_mouse_position()

func release_modifier(tile : Vector2):
	if has_modifier:
		new_modifier.queue_free()
		has_modifier = false
