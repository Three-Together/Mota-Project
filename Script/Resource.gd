extends CharacterBody2D

var plus = {
	"hp":0,
	"atk":100,
	"def":0,
	"ykey":0,
	"bkey":0,
	"rkey":0,
}

func init(pl) -> void:
	plus = pl

func _ready() -> void:
	self.position = snapped(self.position,Global.cell_size)

func _on_body_entered(player: Node2D) -> void:
	if player.name == "Player" && Global.loading == false:
		if player.click_run_times == 0 :
			player.position = snapped(player.position,Global.cell_size)
			player.run_times[player.current_dir] = 0
			
		player.pickup(plus)
		self.queue_free()
