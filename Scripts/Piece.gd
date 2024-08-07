extends Sprite2D

func load_icon(piece_name):
	texture = load(BoardManager.assets[piece_name])
