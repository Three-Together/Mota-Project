extends Node

var hp : int = 100000
var atk : int = 20
var def : int = 10
var arm : int = 0

var money : int = 0
var ykey : int = 0
var bkey : int = 0
var rkey : int = 0
var gkey : int = 0

const Inf_int = 9223372036854775807
var cell_size : Vector2 = Vector2(32,32)
var main_scene : Node2D
var resource_data : Dictionary
var monster_data : Dictionary

var green = LabelSettings.new()	
var white = LabelSettings.new()
var yellow = LabelSettings.new()
var orange = LabelSettings.new()
var red = LabelSettings.new()
var blue = LabelSettings.new()

var game_status = "begin";# "begin","run","fight","pause1","pause2"
var stairs_enable : bool = true
var sl_page : int = 0
var auto_sl_lid : int = 0
var auto_sl_rid : int = -1
var auto_sl_siz : int = 0


func _ready():       
	green.font_color = Color(0.471, 1, 0.314, 1)
	white.font_color = Color(1, 1, 1, 1)	
	yellow.font_color = Color(1, 1, 0.314, 1)
	orange.font_color = Color(1, 0.706, 0.314, 1)	
	red.font_color = Color(1, 0.251, 0.251, 1)
	blue.font_color = Color(0.667,0.667,1,1)				
	var monster_file = FileAccess.open("res://Assert/monster.json",FileAccess.READ)
	var json = JSON.new()  
	var error = json.parse(monster_file.get_as_text())
	if error == OK:
		monster_data = json.data
	else:
		print("MonsterJSON Parse Error")
	monster_file.close()
	var resource_file = FileAccess.open("res://Assert/resource.json",FileAccess.READ)
	error = json.parse(resource_file.get_as_text())
	if error == OK:
		resource_data = json.data
	else:
		print("ResourceJSON Parse Error")
	resource_file.close()

# 根据怪物名称获取怪物信息
func get_info_by_monstername(name:String) -> Dictionary:
	var data = monster_data[name].duplicate()
	if data.has("ability") :
		for node in data.ability :
			if node == "firm" :
				data.def = max(data.def,Global.atk - 1)
			if node == "similar" :
				data.atk = max(data.atk,Global.atk)
				data.def = max(data.def,Global.def)
	return data
	
func get_info_by_resourcename(name:String) -> Dictionary:
	return resource_data[name]
	
func click_effect(position : Vector2) :
	var anim_click = preload("res://Scene/AnimClick.tscn").instantiate()
	main_scene.add_child(anim_click)
	anim_click.play("click")
	anim_click.global_position = position * cell_size

func get_damage_by_monster_name(monster_name : String) -> int:
	var monster_info = get_info_by_monstername(monster_name)
	var cal_player_atk = Global.atk
	var cal_player_def = Global.def
	var cal_player_arm = Global.arm
	var cal_monster_hp = monster_info.hp
	var cal_monster_atk = monster_info.atk
	var cal_monster_def = monster_info.def
	var rnd : int = 0
	var atk_times : int = 1
	var monster_damage :int = 0
	var monster_rnd_damage : int = 0
	var player_rnd_damage : int = 0
	if monster_info.has("ability") :
		for node in monster_info.ability :
			if node == "first_atk" :
				rnd += 1
			if node == "magic_atk" :
				cal_player_def = 0
			if node == "purify" :
				monster_damage += cal_player_arm * monster_info.ability["purify"]
			if node == "many_atk" :
				atk_times = monster_info.ability["many_atk"]
				
	player_rnd_damage  = cal_player_atk - cal_monster_def
	monster_rnd_damage = atk_times * (cal_monster_atk - cal_player_def)
	monster_rnd_damage = max(0,monster_rnd_damage)
	if player_rnd_damage <= 0 :
		return Inf_int		
	rnd += (cal_monster_hp + player_rnd_damage - 1) / player_rnd_damage
	monster_damage += rnd * monster_rnd_damage
	monster_damage -= arm
	monster_damage = max(0, monster_damage)
	return monster_damage
	
func get_color_by_damage(monster_damage : int) -> LabelSettings :
	if monster_damage <= 0 :
		return green
	elif monster_damage <= Global.hp / 3.0 :
		return white
	elif monster_damage <= Global.hp * 2.0 / 3.0 :
		return yellow
	elif monster_damage < Global.hp:
		return orange
	else :
		return red
