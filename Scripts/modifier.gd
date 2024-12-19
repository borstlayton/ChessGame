extends Node2D


@onready var modifier_assets : Array = []
@onready var modifier_ID

func _ready():
	pass
func load_icon(modifier_num : int):
	
	load_array() #have to do this so that the array is initialized before calling this function
	modifier_ID = modifier_num
	self.texture = load(modifier_assets[modifier_num])

func set_ID(ID : int):
	modifier_ID = ID

func load_array():
	modifier_assets.append("res://Art/Cards/Modifiers/Modifier.png")
	modifier_assets.append("res://Art/Cards/Modifiers/SpeedMod.png")
	modifier_assets.append("res://Art/Cards/Modifiers/BalanceMod.png")
	modifier_assets.append("res://Art/Cards/Modifiers/CrimsonMod.png")
	modifier_assets.append("res://Art/Cards/Modifiers/CrownMod.png")
	modifier_assets.append("res://Art/Cards/Modifiers/HeroMod.png")
