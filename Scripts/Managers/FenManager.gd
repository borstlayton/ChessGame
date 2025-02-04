extends Node

var piece_value := {
	"p": 1,
	"n": 3,
	"b": 3,
	"r": 5,
	"q": 9,
	"P": -1,
	"N": -3,
	"B": -3,
	"R": -5,
	"Q": -9
}
var fens := []
func _ready() -> void:
	
	var file = FileAccess.open("res://fen_text.txt", FileAccess.READ)
	var new_line
	var value
	while file.get_position() < file.get_length():
		new_line = file.get_line()
		value = calculate_fen_value(new_line)
		fens.append({"value": value, "fen": new_line})
	
	var test = get_random_fen(1,10)
	print(test)
func calculate_fen_value(fen: String) -> int:
	var total := 0
	for char in fen:
		if piece_value.has(char):
			total += piece_value[char]
	return total

func get_random_fen(lower_bound : int, upper_bound : int):
	var filtered_dict = []
	for key in fens:
		var entry = key
		if entry["value"] >= lower_bound and entry["value"] <= upper_bound:
			filtered_dict.append(entry["fen"])
	return filtered_dict.pick_random()
	
