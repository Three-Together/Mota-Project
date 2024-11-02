extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.main_scene = self
	SceneManager.load_scene(SceneManager.load_by_floor("Floor1"),Vector2(160,160))
	connect("change",myfun)
	emit_signal("change")

func myfun() :
	print(666)
