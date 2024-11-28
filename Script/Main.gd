extends Node2D

var Pause_ui : Node2D;
func _ready() -> void:
	
	Global.main_scene = self
	
func esc_check() :
	if Input.is_action_just_pressed("ui_cancel") :
		if Global.game_status == "run": 
			Global.game_status = "pause1"
			SceneManager.save_screenshot(0)
			Pause_ui = load("res://Scene/Pause_ui.tscn").instantiate()
			self.add_child(Pause_ui)			
		elif Global.game_status == "pause1" and Global.game_status == "pause3":
			Global.game_status = "run"
			Pause_ui.queue_free()
		elif Global.game_status == "pause2":
			Global.game_status = "pause1"
			Pause_ui.emit_signal("back")
				
func backspace_check() :
	if Input.is_action_just_pressed("ui_text_backspace") and Global.game_status == "run" :
		SceneManager.autoload()
	
func _process(delta: float) -> void:
	esc_check() 
	backspace_check() 		
