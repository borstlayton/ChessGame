extends Label

var material_counter = 0
var piece_values = {
	"p": 1,    # Black Pawn
	"n": 3,    # Black Knight
	"b": 3,    # Black Bishop
	"r": 5,    # Black Rook
	"q": 9,    # Black Queen
	"k": 0,
}
func _ready() -> void:
	
	SignalManager.beat_level.connect(change_text)
	
func change_text():
	
	material_counter = parse_level()
	text = str("Your opponent has ", material_counter, " points worth of material")
	
func parse_level():
	var fen = BoardManager.level_fen[BoardManager.current_level+1]
	var boardstate = fen.split(" ")
	var counter = 0
	for i in boardstate[0]:
		if i == "/":continue
		if i.is_valid_int() or (i == i.to_upper()):
			continue
		else:
			counter += piece_values[i]
	return counter
