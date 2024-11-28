extends Node  

# 当前显示的场景  
var current_scene_path = null
var current_scene
var current_player : CharacterBody2D
var floor_file_path : String = "res://Scene/floor/"
var sc_monster_data : Dictionary
var sc_resource_data : Dictionary
var sc_door_data : Dictionary
var sc_npc_data : Dictionary

func _ready() -> void:
	var dir = DirAccess.open("user://")
	if dir.dir_exists("image") == false:
		dir.make_dir("image")
	if dir.dir_exists("save") == false:
		dir.make_dir("save")

func load_by_floor(name: String) -> String:
	var next_floor = "%s%s%s" % [floor_file_path,name,".tscn"]
	return next_floor

func save_current_scene() :
	var monster_data : Dictionary;
	for node in current_scene.get_tree().get_nodes_in_group("Monster") :
		monster_data[node.name] = 1
	sc_monster_data[current_scene_path] = monster_data
	
	var resource_data : Dictionary;
	for node in current_scene.get_tree().get_nodes_in_group("Resource") :
		resource_data[node.name] = 1
	sc_resource_data[current_scene_path] = resource_data
	
	var door_data : Dictionary;
	for node in current_scene.get_tree().get_nodes_in_group("Door") :
		door_data[node.name] = 1
	sc_door_data[current_scene_path] = door_data
	
	var npc_data : Dictionary;
	for node in current_scene.get_tree().get_nodes_in_group("NPC") :
		npc_data[node.name] = 1
	sc_npc_data[current_scene_path] = npc_data
	
func update_current_scene() :
	var monster_data = sc_monster_data[current_scene_path]
	for node in current_scene.get_tree().get_nodes_in_group("Monster") :	
		if monster_data.has(node.name) == false :
			node.queue_free() 
	
	var resource_data = sc_resource_data[current_scene_path]
	for node in current_scene.get_tree().get_nodes_in_group("Resource") :	
		if resource_data.has(node.name) == false :
			node.queue_free() 
			
	var door_data = sc_door_data[current_scene_path]
	for node in current_scene.get_tree().get_nodes_in_group("Door") :	
		if door_data.has(node.name) == false :
			node.queue_free() 
			
	var npc_data = sc_npc_data[current_scene_path]
	for node in current_scene.get_tree().get_nodes_in_group("NPC") :	
		if npc_data.has(node.name) == false :
			node.queue_free() 
	
func return_title() :
	current_scene.queue_free()
	current_scene_path = null
	current_scene = null
	current_player = null
	sc_monster_data.clear()
	sc_resource_data.clear()
	sc_door_data.clear()
	sc_npc_data.clear() 
	Global.game_status = "begin"
	Global.main_scene.get_child(1).visible = true
	
func load_scene_deferred(target_path : String,player_position : Vector2,dir : String = "null") :
	call_deferred("load_scene", target_path, player_position, dir)	

# 加载并切换场景的函数  
func load_scene(target_path : String,player_position : Vector2, dir : String = "null"):  
	# 如果场景已经加载过，则直接使用已加载的场景实例  
	if current_scene_path != null :
		save_current_scene()
		current_scene.queue_free() 

	current_scene_path = target_path  	
	current_scene = load(current_scene_path).instantiate()
		
	Global.main_scene.get_child(0).add_child(current_scene)  			
	instance_player(current_scene,player_position, dir)	
	
	if sc_monster_data.has(current_scene_path): #任选一个存档集进行检测
		update_current_scene()
		
  
func instance_player(next_floor:Node2D,position:Vector2,dir : String = "null") -> void:
	var player = load("res://Scene/Player.tscn").instantiate()
	player.global_position = snapped(position,Global.cell_size)
	player.current_dir = dir
	player.map_node = next_floor.get_child(1)
	next_floor.add_child(player)
	current_player = player
	
func save_screenshot(id : int):
	var image = self.get_viewport().get_texture().get_image()
	var image_path = "%s%s%s" % ["user://image/image",str(id),".png"]
	image.resize(720,480)
	image.get_region(Rect2i(0,0,640,480)).save_png(image_path)
	
func save_data(id : int):
	var data = SceneData.new()
	var save_path
	if id > 0 :
		save_path = "%s%s%s" % ["user://save/save",str(id),".res"]
	else :
		id = -id
		save_path = "%s%s%s" % ["user://save/autosave",str(id),".res"]
	SceneManager.save_current_scene()
	data.playerposition = SceneManager.current_player.position
	data.playerdir = SceneManager.current_player.current_dir
	data.atk = Global.atk
	data.def = Global.def
	data.hp = Global.hp
	data.arm = Global.arm
	data.money = Global.money
	data.ykey = Global.ykey
	data.bkey = Global.bkey
	data.rkey = Global.rkey
	data.gkey = Global.gkey
	data.current_scene_path = SceneManager.current_scene_path
	data.scene_monster_data = SceneManager.sc_monster_data
	data.scene_resource_data= SceneManager.sc_resource_data
	data.scene_door_data = SceneManager.sc_door_data
	data.scene_npc_data = SceneManager.sc_npc_data
	data.sl_page = Global.sl_page
	data.auto_sl_lid = Global.auto_sl_lid
	data.auto_sl_rid = Global.auto_sl_rid
	data.auto_sl_siz = Global.auto_sl_siz
	data.stairs_enable = Global.stairs_enable
	ResourceSaver.save(data,save_path)

func load_data(id : int) -> bool :
	var load_path
	if id > 0 :
		load_path = "%s%s%s" % ["user://save/save",str(id),".res"]
	else :
		id = -id
		load_path = "%s%s%s" % ["user://save/autosave",str(id),".res"]
	
	var data : SceneData = ResourceLoader.load(load_path) as SceneData
			
	if data == null :
		return false
		
	if SceneManager.current_scene_path != null :
		SceneManager.current_scene.queue_free()
		SceneManager.current_scene_path = null
		SceneManager.current_scene = null
				
	SceneManager.sc_monster_data = data.scene_monster_data
	SceneManager.sc_resource_data = data.scene_resource_data
	SceneManager.sc_door_data = data.scene_door_data
	SceneManager.sc_npc_data = data.scene_npc_data
	SceneManager.load_scene_deferred(data.current_scene_path,data.playerposition,data.playerdir)	
	Global.atk = data.atk
	Global.def = data.def 
	Global.hp = data.hp 
	Global.arm = data.arm
	Global.money = data.money
	Global.ykey = data.ykey
	Global.bkey = data.bkey
	Global.rkey = data.rkey
	Global.gkey = data.gkey
	Global.main_scene.get_child(1).visible = false
	Global.sl_page = data.sl_page
	Global.stairs_enable = data.stairs_enable
	
	return true

func autosave() :
	if Global.auto_sl_siz != 0 and (Global.auto_sl_rid + 1) % 20 == Global.auto_sl_lid :
		Global.auto_sl_lid = (Global.auto_sl_lid + 1) % 20
	else :
		Global.auto_sl_siz += 1
	Global.auto_sl_rid = (Global.auto_sl_rid + 1) % 20
	save_data(-Global.auto_sl_rid)
	
func autoload() :
	if Global.auto_sl_siz == 0:
		return
	Global.auto_sl_siz -= 1
	SceneManager.load_data(-Global.auto_sl_rid)
	Global.auto_sl_rid = (Global.auto_sl_rid + 19) % 20
	
	
