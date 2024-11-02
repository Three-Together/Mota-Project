extends Node

const Inf_int = 9223372036854775807
var stairs_enable : bool = true
var loading : bool = false
var cell_size : Vector2 = Vector2(32,32)
var hp : int = 10
var atk : int = 0
var def : int = 100
var main_scene : Node2D
var resource_data : Dictionary


#func _ready() -> void:
	#var file = FileAccess.open("res://Assert/resource.json",FileAccess.READ)
	#var json = JSON.new()
	#var error = json.parse(file.get_as_text())
	#if error == OK:
		#resource_data = json.data
	#else:
		#print("JSON Parse Error")
	#file.close()
#
#func get_info_by_name(name:String) -> Dictionary:
	#return resource_data[name]

#var UI = preload("res://Scene/ui.tscn")
#var player = preload("res://Scene/player.tscn")
#var resource = preload("res://Scene/resource.tscn")
#
#func instance_scene(target_scene,parent,position):
	#var target = target_scene.instantiate()
	#parent.add_child(target)
	#target.global_position = position
	#return target
#
#func instance_path(target_path,parent):
	#var target = load(target_path).instantiate()
	#parent.add_child(target)
	#return target
#
#func instance_content(target_scene,parent,position,type,content):
	#var target = instance_scene(target_scene,parent,position)
	#target.init(type,content)
	#return target
