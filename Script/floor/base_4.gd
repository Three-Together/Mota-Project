extends Node2D

func _ready() -> void:
	$stairs.scene_name = "base_3"
	$stairs.player_position = Vector2(416,32)
	$stairs2.scene_name = "base_5"
	$stairs2.player_position = Vector2(224,416)
