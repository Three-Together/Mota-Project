extends Node2D


func _ready() -> void:
	$stairs.scene_name = "base_1"
	$stairs.player_position = Vector2(416,32)
	$stairs2.scene_name = "base_3"
	$stairs2.player_position = Vector2(32,416)
