extends Control

@onready var play_button = $PlayButton
@onready var title = $Title
@onready var _screen_size_x = get_viewport_rect().size.x
@onready var _screen_size_y = get_viewport_rect().size.y

# Called when the node enters the scene tree for the first time.
func _ready():
	#Center the position of the Title and PlayButton
	title.position = Vector2((_screen_size_x-title.get_rect().size.x)/2,_screen_size_y/5)
	play_button.position = Vector2((_screen_size_x-play_button.get_rect().size.x)/2,_screen_size_y/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	var board = load("res://Scenes/Board.tscn").instantiate()
