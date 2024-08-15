extends Label


func _process(_delta):
	text = str(ShopManager.current_coin_amount)
