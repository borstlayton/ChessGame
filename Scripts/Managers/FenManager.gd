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
var fen_lower_bounds := {
	0: -5,
	1: -3,
	2: -1,
	3: 3,
	4: 5,
	5: 7,
	6: 9,
	7: 10,
	8: 12,
	9: 14,
	10: 16,
	11: 18,
	12: 19,
	13: 21,
	14: 22,
	15: 24,
	16: 26,
	17: 29,
	18: 32,
	19: 34,
}
var fen_upper_bounds := {
	0: -3,
	1: -1,
	2: 2,
	3: 6,
	4: 8,
	5: 10,
	6: 13,
	7: 15,
	8: 17,
	9: 18,
	10: 20,
	11: 21,
	12: 23,
	13: 24,
	14: 25,
	15: 27,
	16: 30,
	17: 33,
	18: 35,
	19: 38,
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
	var rand = filtered_dict.pick_random()
	print(rand)
	return rand
	
