extends Sprite2D

#@export var from: Control
#@export var card_offset_x: float = 20.0
#@export var rot_max: float = 10.0
#@export var anim_offset_y: float = 0.3
#@export var time_multiplier: float = 2.0
#@onready var grid1 = $"../ModifierCardsBackground/ModifierCardDisplay/CardContainer"
#@onready var grid2 = $"../BountyAndPermaBackground/BountyandPermaDisplay/CardContainer"
#
#var tween: Tween
#
#func draw_cards(from_pos: Vector2, number: int) -> void:
	#var total_grids = 2
	#var grid_containers = [grid1, grid2]
	#var cards_per_container = ceil(number / float(total_grids))
#
	#tween = create_tween()
	#for i in range(number):
		#var instance: Button = card_scene.instantiate()
		#add_child(instance)
		#instance.global_position = from_pos  # Start at the "from" position
	   ## Choose target grid and position
		#var target_grid = grid_containers[i / cards_per_container]
		#var target_pos = target_grid.global_position + Vector2(0, 0)  # Adjust as needed
	   ## Animate the card
		#tween.parallel().tween_property(instance, "global_position", target_pos, 0.5 + (i * 0.1))
