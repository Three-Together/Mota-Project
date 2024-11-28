extends Node2D

var cur_player : Node2D

func _ready() -> void:
	$".".play(self.animation)
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
		player.position = snapped(player.position,Global.cell_size)
		player.click_run_times = 0;
		player.play_anim(0)
		Event.call(self.name)
		if self.name.contains("once") :
			await(Event.delnpc)
			self.queue_free()	
