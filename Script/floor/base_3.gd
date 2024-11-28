extends Node2D


func _ready() -> void:
	$stairs.scene_name = "base_2"
	$stairs.player_position = Vector2(416,32)
	$stairs2.scene_name = "base_4"
	$stairs2.player_position = Vector2(32,416)
