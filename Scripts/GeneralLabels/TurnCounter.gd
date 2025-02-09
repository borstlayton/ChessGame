extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.turn_change.connect(change_text)
	SignalManager.next_level_selected.connect(change_text)
	text = str("0")
	
func change_text():
	text = str(BoardManager.turn_counter, "/", BoardManager.turns_per_level[BoardManager.current_level] )
