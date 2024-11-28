extends Node2D


func _on_start_pressed() -> void:
	self.visible = false
	Global.hp = 10
	Global.atk = 1
	Global.def = 0
	Global.arm = 0
	Global.ykey = 0
	Global.bkey = 0
	Global.rkey = 0
	Global.gkey = 1000
	Global.game_status = "run"
	SceneManager.load_scene_deferred(SceneManager.load_by_floor("Floor1"),Vector2(224,416))

func _on_load_pressed() -> void:
	var Pause_ui = load("res://Scene/Pause_ui.tscn").instantiate()
	Global.main_scene.Pause_ui = Pause_ui
	Global.main_scene.add_child(Pause_ui)
	Pause_ui._to_load_button_preessed()
	Global.game_status = "pause3"
	
	


func _on_setting_pressed() -> void:
	get_tree().quit()
