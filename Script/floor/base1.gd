extends Node2D


func _ready() -> void:
	$stairs.scene_name = "start_hoom"
	$stairs.player_position = Vector2(222,288)
	$stairs2.scene_name = "base_2"
	$stairs2.player_position = Vector2(32,416)
