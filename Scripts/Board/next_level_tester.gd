extends Button




func _on_button_down() -> void:
	SignalManager.beat_level.emit()
