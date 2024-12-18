extends Control


func _ready() -> void:
	hide()
	SignalManager.beat_level.connect(show)
	SignalManager.next_level_selected.connect(hide)
