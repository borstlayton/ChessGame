extends GridContainer

var original_color = Color("b52d00")
func show_tiles(tiles_shown):
	for tile in tiles_shown:
		var ID = 8*tile.x + tile.y
		get_child(ID).set_color(Color.DARK_OLIVE_GREEN)
func clear_valid_tiles():
	for i in range(8):
		for j in range(8):
			var current_tile = get_child(8*i+j)
			if (j+i)%2 == 0:
				current_tile.set_color(Color.BEIGE)
			else:
				current_tile.set_color(original_color)
