class_name Card extends Node2D

@export var card_name : String
@export var card_ID : int
@export var base_cost: int
@export var card_image: Sprite2D



func _on_area_2d_mouse_entered():
	print("entered")


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Left click detected on Area2D!")
