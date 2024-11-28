extends Node2D

func _ready() -> void:
	$stairs.scene_name = "Floor1"
	$stairs.player_position = Vector2(224,32)
	$stairs2.scene_name = "start_hoom"
	$stairs2.player_position = Vector2(222,288)
