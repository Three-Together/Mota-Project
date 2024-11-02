extends Node2D

@export var player : Node2D 

func _process(delta: float) -> void:	
	if $AttackLable.text != str(Global.atk) :
		emit_signal("change")
		$AttackLable.text = str(Global.atk)
	if $DefenseLable.text != str(Global.def) :
		emit_signal("change")
		$DefenseLable.text = str(Global.def)
	if $HPLable.text != str(Global.hp) :
		emit_signal("change")
		$HPLable.text = str(Global.hp)

func _on_save_pressed() -> void:
	var data = SceneData.new()
	data.playerposition = player.position
	data.playerdir = player.current_dir
	data.playeratk = Global.atk
	data.playerdef = Global.def
	data.playerhp = Global.hp
	SceneManager.update_current_scene()
	var pack = PackedScene.new()
	pack.pack(SceneManager.current_scene)	
	data.current_scene_path = SceneManager.current_scene_path
	data.current_scene_pack = pack
	data.scene_data = SceneManager.scene_data
	ResourceSaver.save(data,"user://scenedata.tres")


func _on_load_pressed() -> void:
	Global.loading = true
	var data : SceneData = ResourceLoader.load("user://scenedata.tres") as SceneData
	if SceneManager.current_scene_path != null :
		SceneManager.current_scene.queue_free()
		SceneManager.current_scene_path = null
		SceneManager.current_scene = null
	SceneManager.scene_data = data.scene_data
	SceneManager.scene_data[data.current_scene_path] = data.current_scene_pack
	SceneManager.load_scene(data.current_scene_path,data.playerposition)	
	player.current_dir = data.playerdir 
	Global.atk = data.playeratk
	Global.def = data.playerdef 
	Global.hp = data.playerhp 
	Global.loading = false
