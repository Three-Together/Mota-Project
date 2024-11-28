extends Area2D

func _ready() -> void:
	self.position = snapped(self.position,Global.cell_size)
	add_to_group("NPC")

		
func _on_body_entered(player: Node2D) -> void:
	if player.name == "Player" and Global.game_status == "run":
		Global.game_status = "talk"
		player.current_path.clear()
		player.run_times.right = 0
		player.run_times.left = 0
		player.run_times.up = 0
		player.run_times.down = 0
		player.click_run_times = 0;
		player.position = snapped(player.position,Global.cell_size)
		player.play_anim(0)
		await(Event.call(self.name))
		Global.game_status = "run"
		self.queue_free()
