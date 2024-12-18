extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.turn_change.connect(change_text)
	SignalManager.next_level_selected.connect(change_text)
	text = str("Current turn: 0")
	
func change_text():
	text = str("Current turn: ", BoardManager.turn_counter)
