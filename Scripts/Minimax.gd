extends Node2D

@onready var board = BoardManager.current_board
@onready var turn : bool = BoardManager.turn
@export var best_move : Vector4 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var values := { "P" = 1, "p" = -1, 
	"B" = 3, "b" = -3, 
	"N" = 2.9, "n" = -2.9, 
	"R" = 5, "r" = -5, 
	"Q" = 9, "q" = -9, 
	"K" = 0, "k" = 0,
	"0" = 0,}

func _eval():
	var count = 0
	var val
	for row in range(8):
		for column in range(8):
			val = values.board[row][column]
			if val == 1:
				val *= 1.1**row
			elif val == -1:
				val *= 1.1**(7 - row)
			else:
				if row >= 2 and row <= 5:
					val *= 1.05
				if row >= 3 and row <= 4:
					val *= 1.05
				if column >= 2 and column <= 5:
					val *= 1.05
				if column >= 3 and column <= 4:
					val *= 1.05
			count += val
	return count
	
func generate_children():
	BoardManager.generate_moves()
	pass

func _minmax():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
