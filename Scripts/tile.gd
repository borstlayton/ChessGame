extends ColorRect

var ID
var tile_row
var tile_column

		
func set_id(row, column):
	ID = row*8 + column
	tile_row = row
	tile_column = column
func _on_button_button_down():
	BoardManager.show_valid_tiles(tile_row, tile_column)
func _on_button_button_up():
	BoardManager.clear_tiles()
