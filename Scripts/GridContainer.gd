extends GridContainer

var original_color = Color("b52d00")

func show_tiles(tiles_shown):
	if tiles_shown == null:
		return
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
func move_pieces(past_tile : Vector2, next_tile : Vector2): #NOT IN USE YET
	var past_ID = past_tile.x * 8 + past_tile.y
	var next_tile_ID = next_tile.x*8 + next_tile.y
	
	get_child(next_tile_ID).set_icon(get_child(past_ID.get_icon()))
