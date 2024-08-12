extends ColorRect

var ID
var tile_row
var tile_column
var num_clicks := 0
		
func set_id(row, column):
	ID = row*8 + column
	tile_row = row
	tile_column = column
func _on_button_button_down():
	BoardManager.show_valid_tiles(tile_row, tile_column)
	num_clicks += 1
func _on_button_button_up():
	BoardManager.clear_tiles()
	num_clicks += 1
