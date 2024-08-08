extends ColorRect

var ID
var button_down = false
var tile_row
var tile_column

func _process(_delta):
	if button_down:
		BoardManager.show_valid_tiles(tile_row, tile_column)

func set_id(row, column):
	ID = row*8 + column
	tile_row = row
	tile_column = column

func _on_button_button_down():
	button_down = true

func _on_button_button_up():
	button_down = false
