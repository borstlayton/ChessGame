extends Node2D

@onready var tile_scene = preload("res://Scenes/tile.tscn")
@onready var grid_container = $ColorRect/GridContainer

var player_move = true

var alternate_color = Color.BEIGE
func _ready():
	for i in range(8):
		for j in range(8):
			var new_slot = tile_scene.instantiate()
			if (j+i)%2 == 0:
				new_slot.set_color(alternate_color)
			grid_container.add_child(new_slot)
			
func place(object)
