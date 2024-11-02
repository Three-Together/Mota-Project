extends Node2D

var monster_info : Dictionary
var monster_damage : int
var cur_player : Node2D

func _ready() -> void:
	monster_info = MonsterBook.get_info_by_name(self.animation)
	$".".play(self.animation)
	self.position = snapped(self.position,Global.cell_size)
	#add_to_group("monster")

func _process(delta: float) -> void:
	getdamage()
		
func _on_body_entered(player: Node2D) -> void:
	if player.name == "Player" and Global.loading == false:
		cur_player = player
		if Global.hp > monster_damage :
			$die.visible = true
			$die.play("sword")
			Global.hp -= monster_damage
		else :
			cur_player.current_path.clear()
			cur_player.run_times.right = 0
			cur_player.run_times.left = 0
			cur_player.run_times.up = 0
			cur_player.run_times.down = 0
			cur_player.position = snapped(cur_player.position,Global.cell_size)
			cur_player.click_run_times = 0;
			print("你打不过!")

func getdamage() :
	var Tack : int = (Global.atk - monster_info.def) as int
	if Tack <= 0 :
		monster_damage = Global.Inf_int
		$damageLabel.text = "????"
		#print($damageLabel.label_settings.font_color)
		$damageLabel.label_settings.font_color = Color(1, 0.251, 0.251, 1)
		#print($damageLabel.label_settings.font_color)
		return
	var rnd : int = (monster_info.hp + Tack - 1) / Tack
	monster_damage = rnd * max(0,(monster_info.atk - Global.def))
	$damageLabel.text = str(monster_damage)
	if monster_damage <= 0 :
		$damageLabel.label_settings.font_color = Color(0.471, 1, 0.314, 1)
	elif monster_damage <= Global.hp / 3 :
		$damageLabel.label_settings.font_color = Color(1, 1, 1, 1)	
	elif monster_damage <= Global.hp * 2 / 3 :
		$damageLabel.label_settings.font_color = Color(1, 1, 0.314, 1)
	elif monster_damage <= Global.hp:
		$damageLabel.label_settings.font_color = Color(1, 0.706, 0.314, 1)	
	else :
		$damageLabel.label_settings.font_color = Color(1, 0.251, 0.251, 1)	

func _on_die_animation_finished() -> void:
	if cur_player.click_run_times == 0 :
		cur_player.position = snapped(cur_player.position,Global.cell_size)
		cur_player.run_times[cur_player.current_dir] = 0
	self.queue_free()
