extends Node2D

var scene_name : String
var player_position : Vector2
var enable = true
func _on_body_entered(body: Node2D) -> void:
	if Global.stairs_enable == true && Global.loading == false:
		Global.stairs_enable = false
		enable = false
		var next_floor_path = SceneManager.load_by_floor(scene_name)
		SceneManager.load_scene(next_floor_path,player_position)
		

func _on_body_exited(body: Node2D) -> void:
	if enable == true && Global.loading == false:	
		Global.stairs_enable = true
