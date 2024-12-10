extends Button

@onready var modifier_scene = preload("res://Scenes/Modifier.tscn")

func _on_button_down() -> void:
	var new_modifer = modifier_scene.instantiate()
	add_child(new_modifer)
