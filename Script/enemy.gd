extends CharacterBody2D

var playercheck : bool = false
var playerbody = null
var Status = {
	"hp":100,
	"attack":2,
	"defense":1,
	"damage":INF,
}

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func _process(delta: float) -> void:
	getdamage()
		
func _on_body_entered(playerbody: Node2D) -> void:
	if playerbody.name == "player" :
		if Global.PlayerStatus["hp"] > Status["damage"] :
			playerbody.position = snapped(playerbody.position,Vector2(16,16))
			playerbody.runtimes["right"] = 0
			playerbody.runtimes["left"] = 0
			playerbody.runtimes["up"] = 0
			playerbody.runtimes["down"] = 0
			Global.PlayerStatus["hp"] -= Status["damage"]
			playerbody.world.updateStatus()
			self.queue_free()
		else :
			print("你打不过!")

func getdamage() :
	var Tack = Global.PlayerStatus["attack"] - Status["defense"]
	if Tack <= 0 :
		$damageLabel.text = "????"
		return
	var round = Status["hp"] / Tack
	if Status["hp"] % Tack != 0 :
		round += 1
	Status["damage"] = round * Status["attack"]
	$damageLabel.text = str(Status["damage"])
