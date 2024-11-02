extends Node  

# 当前显示的场景  
var current_scene_path = null
var current_scene = null
var scene_data : Dictionary = {}
var floor_file_path : String = "res://Scene/floor/"

func load_by_floor(name: String) -> String:
	var next_floor = "%s%s%s" % [floor_file_path,name,".tscn"]
	return next_floor

func update_current_scene() :
	var scene = PackedScene.new()
	scene.pack(current_scene)	
	scene_data[current_scene_path] = scene

# 加载并切换场景的函数  
func load_scene(target_path : String,player_position : Vector2):  
	# 如果场景已经加载过，则直接使用已加载的场景实例  
	if current_scene_path != null :
		update_current_scene()
		current_scene.queue_free() 

	if scene_data.has(target_path):  
		current_scene_path = target_path
		current_scene = scene_data[target_path].instantiate()
	else:  
		# 否则，加载新场景并存储到字典中
		current_scene_path = target_path  
		current_scene = load(target_path).instantiate()
		
	Global.main_scene.add_child(current_scene)  
	instance_player(current_scene,player_position)	
  

func instance_player(next_floor:Node2D,position:Vector2) -> void:
	var player = load("res://Scene/Player.tscn").instantiate()
	player.global_position = position
	player.map_node = next_floor.get_child(1)
	next_floor.add_child(player)
	Global.main_scene.get_child(0).player = player
	
