extends Node

var monster_data : Dictionary

# 根据json文件初始化怪物数据
func _ready():
	var file = FileAccess.open("res://Assert/monster.json",FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		monster_data = json.data
	else:
		print("JSON Parse Error")
	file.close()

# 根据怪物名称获取怪物信息
func get_info_by_name(name:String) -> Dictionary:
	return monster_data[name]
	
# 获取所有怪物名称
#func get_monsters_name() -> Array:
	#if monster_data == null:
		#return []
	#return monster_data.keys()



# 显示怪物图鉴
#func show():
	#var monster_set = {}
	#for monster in get_tree().get_nodes_in_group("monster"):
		#if monster is AnimatedSprite:
			#monster_set[monster.animation] = -1
	##清理旧视图
	#for child in container.get_children():
		#container.remove_child(child)
	##增加子项视图
	#for monster_name in monster_set.keys():
		#var monster_info = get_info_by_name(monster_name)
		#var item = load("res://src/monster/MonsterBookItem.tscn").instance() as PanelContainer
		##设置图标
		#item.get_node("Content/MonsterImageBackground/MonsterImage").animation = monster_name
		##设置名称
		#item.get_node("Content/MonsterName").text = monster_info.name
		##设置血量
		#item.get_node("Content/MonsterHp/HpValue").text = monster_info.hp as String
		##设置攻击力
		#item.get_node("Content/MonsterAtk/AtkValue").text = monster_info.atk as String
		##设置防御力
		#item.get_node("Content/MonsterDef/DefValue").text = monster_info.def as String
		##设置金钱
		#item.get_node("Content/MonsterMoney/MoneyValue").text = monster_info.money as String
		#container.add_child(item)
	#dialog.popup()
	#dialog.get_node("ScrollContainer").set_process_input(true)
