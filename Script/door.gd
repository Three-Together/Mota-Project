extends Node2D

var need_key : int
var door_type : String
var player_has : String
var cur_player : Node2D

func _ready() -> void:
	self.position = snapped(self.position,Global.cell_size)
	if self.animation == "ydoor":
		door_type = "ydoor"
		need_key = 1
		player_has = "ykey"
	elif self.animation == "bdoor" :
		door_type = "bdoor"
		need_key = 1
		player_has = "bkey"
	elif self.animation == "rdoor" :
		door_type = "rdoor"
		need_key = 1
		player_has = "rkey"	
	elif self.animation == "gdoor" :
		door_type = "gdoor"
		need_key = 1
		player_has = "gkey"	
	add_to_group("Door")



func _on_body_entered(player: Node2D) -> void:
	if player.name == "Player" and Global.game_status == "run":
		if self.animation == "mdoor" :
			player.current_path.clear()
			player.run_times.right = 0
			player.run_times.left = 0
			player.run_times.up = 0
			player.run_times.down = 0
			player.position = snapped(player.position,Global.cell_size)
			player.click_run_times = 0;
			return
		SceneManager.autosave()
		if Global[player_has] >= need_key:
			Global.game_status = "fight"
			$".".play(door_type)
			await($".".animation_finished)
			Global[player_has] -= need_key
			player.position = snapped(player.position,Global.cell_size)
			if player.click_run_times == 0 :
				player.run_times[player.current_dir] = 0	
			self.queue_free()
			Global.game_status = "run"
		else :
			player.current_path.clear()
			player.run_times.right = 0
			player.run_times.left = 0
			player.run_times.up = 0
			player.run_times.down = 0
			player.position = snapped(player.position,Global.cell_size)
			player.click_run_times = 0;

func _on_child_exiting_tree(node: Node) -> void:
	if self.animation == "mdoor" and self.get_child_count() == 2:
		$".".play(door_type)
		await($".".animation_finished)
		self.queue_free()
	
