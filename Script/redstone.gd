extends CharacterBody2D



var Plus = {
	"hp":0,
	"attack":1,
	"defense":0,
}

func _on_body_entered(playerbody: Node2D) -> void:
	if playerbody.name == "player" :
		playerbody.position = snapped(playerbody.position,Vector2(16,16))
		playerbody.runtimes["right"] = 0
		playerbody.runtimes["left"] = 0
		playerbody.runtimes["up"] = 0
		playerbody.runtimes["down"] = 0
		playerbody.pickup(Plus)
		playerbody.world.updateStatus()
		self.queue_free()
