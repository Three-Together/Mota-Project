extends Node2D

var monster_damage : int
var cur_player : Node2D
var monster_info : Dictionary
func _ready() -> void:
	$".".play(self.animation)
	self.position = snapped(self.position,Global.cell_size)
	monster_info = Global.get_info_by_monstername(self.animation)
	add_to_group("Monster")
	

func _process(delta: float) -> void:
	monster_damage = Global.get_damage_by_monster_name(self.animation)
	update_label()
		
	
	
		
func _on_body_entered(player: Node2D) -> void:
	if player.name == "Player" and Global.game_status == "run":
		Global.game_status = "fight"
		SceneManager.autosave()
		if Global.hp > monster_damage :	
			$die.visible = true
			$damageLabel.visible = false
			$die.play("sword")
			await($die.animation_finished)
			Global.hp -= monster_damage
			Global.money += monster_info.money
			player.position = snapped(player.position,Global.cell_size)
			if player.click_run_times == 0 :
				player.run_times[player.current_dir] = 0	
			self.queue_free()
			Global.game_status = "run"
		else :
			DialogueManager.show_dialogue_balloon("res://Balloon/Talk_balloon_4.tscn",load("res://dialogue.dialogue"),"die")

func update_label() :
	if monster_damage < Global.Inf_int :
		$damageLabel.text = str(monster_damage)
	else :
		$damageLabel.text = "????"
	$damageLabel.label_settings = Global.get_color_by_damage(monster_damage)	
