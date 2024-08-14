extends Sprite2D


func load_icon(piece_name : int):
	self.texture = load(BoardManager.assets[piece_name])
