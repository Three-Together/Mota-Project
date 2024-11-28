extends Node

var ability_name : Dictionary = {
	"first_atk" = "先攻",
	"firm" = "坚固",
	"magic_atk" = "魔攻",
	"similar" = "模仿",
	"many_atk" = "连击",
	"purify" = "倍净化",
}

func _ready() -> void:
	show()
	
func _process(delta: float) -> void:
	if Global.game_status == "pause2" or Global.game_status == "pause3":
		if Input.is_action_just_pressed("ui_left") :
			Global.sl_page = (Global.sl_page + 99) % 100
		if Input.is_action_just_pressed("ui_right") :
			Global.sl_page = (Global.sl_page + 101) % 100
		for button in get_tree().get_nodes_in_group("SaveButton") :
			var new_button_text : String = "%s%s" % ["存档",str(button.name.to_int() + Global.sl_page * 10)]
			button.text = new_button_text
		for button in get_tree().get_nodes_in_group("LoadButton") :
			var new_button_text : String = "%s%s" % ["读档",str(button.name.to_int() + Global.sl_page * 10)]
			button.text = new_button_text

func close_UI_1() :
	$Monster.visible = false
	$Save.visible = false
	$Load.visible = false
	$Exit.visible = false
	$ScrollContainer.visible = false

func get_ability_name(name : String, num : int) :
	var show_name = ability_name[name]
	if name == "many_atk" :
		show_name = "%s%s" % [str(num),show_name]
	elif name == "purify" :
		show_name = "%s%s" % [str(num),show_name]
	return show_name
# 显示怪物图鉴
func show():
	var monster_set = {}
	for monster in get_tree().get_nodes_in_group("Monster"):
		monster_set[monster.animation] = 1
	#增加子项视图
	for monster_name in monster_set.keys():
		var monster_info = Global.get_info_by_monstername(monster_name)
		var item = load("res://Scene/MonsterBookUnit.tscn").instantiate() as PanelContainer
		#设置图标
		var item_sprite = item.get_node("Control/AnimatedSprite2D") 
		item_sprite.animation = monster_name
		item_sprite.play(item_sprite.animation)
		#设置名称
		item.get_node("Control/Name").text = monster_info.name
		#设置血量
		item.get_node("Control/Hp/HpValue").text = str(monster_info.hp)
		#设置攻击力
		item.get_node("Control/Atk/AtkValue").text = str(monster_info.atk)
		#设置防御力
		item.get_node("Control/Def/DefValue").text = str(monster_info.def)
		#设置金币
		item.get_node("Control/Money/MoneyValue").text = str(monster_info.money)
		#设置属性
		if monster_info.has("ability") :
			var i = 1;
			for node in monster_info.ability :
				var path = "%s%s" % ["Control/ability",str(i)]
				item.get_node(path).text = get_ability_name(node,monster_info.ability[node])
				i += 1
				if(i > 4) :
					break
		#设置伤害
		var item_damage = item.get_node("Control/Damage/DamageValue")
		var damage_value = Global.get_damage_by_monster_name(monster_name)
		if damage_value == Global.Inf_int :
			item_damage.text = "????"
		else :
			item_damage.text = str(damage_value)
			
		item_damage.label_settings = Global.get_color_by_damage(damage_value)
		$ScrollContainer/MonsterContainer.add_child(item)
		
func back_last() :
	$Monster.visible = true
	$Save.visible = true
	$Load.visible = true
	$Exit.visible = true
	$ScrollContainer.visible = true
	$SaveContainer.visible = false
	$LoadContainer.visible = false
	$Save_Image.visible = false
	
func _mouse_entered_button(id : int) :	
	id = id + Global.sl_page * 10
	var image_path = "%s%s%s" % ["user://image/image",str(id),".png"]
	var image = Image.new()
	var error = image.load(image_path)
	if	error != OK :
		$Save_Image.visible = false
		return
	$Save_Image.visible = true
	var new_texture = ImageTexture.new()
	new_texture.set_image(image)
	$Save_Image.texture = new_texture
	
func _to_save_button_preessed() -> void:
	close_UI_1()
	$SaveContainer.visible = true
	Global.game_status = "pause2"
	for button in get_tree().get_nodes_in_group("SaveButton") :
		var new_button_text : String = "%s%s" % ["存档",str(button.name.to_int() + Global.sl_page * 10)]
		button.text = new_button_text
		
func _to_load_button_preessed() -> void:
	close_UI_1()
	$LoadContainer.visible = true
	Global.game_status = "pause2"	
	for button in get_tree().get_nodes_in_group("LoadButton") :
		var new_button_text : String = "%s%s" % ["读档",str(button.name.to_int() + Global.sl_page * 10)]
		button.text = new_button_text
			
func _on_save_button_pressed(id : int) -> void:
	id = id + Global.sl_page * 10
	var current_image = Image.new()
	var image_path = "%s%s%s" % ["user://image/image",str(id),".png"]
	current_image.load("user://image/image0.png")
	current_image.save_png(image_path)
	SceneManager.save_data(id)
	Global.game_status = "run"
	self.queue_free();

func _on_load_button_pressed(id : int) -> void:
	id = id + Global.sl_page * 10
	if SceneManager.load_data(id) == false :
		return
	Global.game_status = "run"
	self.queue_free()

func _on_exit_button_pressed() :
	SceneManager.return_title()
	self.queue_free()
