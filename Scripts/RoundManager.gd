extends Node

var RoundTotal = 0

func change_total(piece : String):
	var white : bool #checking if the piece captrued was white
	
	if piece == piece.to_upper():
		white = true
	elif piece == piece.to_lower():
		white = false
		
	var multiplyer = 1 if(white) else -1
