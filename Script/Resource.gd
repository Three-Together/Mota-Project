extends Node2D

var resource_data : Dictionary
var anim_atk : Array[String] = ["atkstone_1","atkstone_2"]
var anim_def : Array[String] = ["defstone_1","defstone_2"]
func _ready() -> void:
	resource_data = Global.get_info_by_resourcename(self.animation)
	$".".play(self.animation)
	self.position = snapped(self.position,Global.cell_size)
	add_to_group("Resource")
	update_label()

func update_label() -> void:
	var zero :int = 0
	if resource_data.atk == 0 :
		zero+= 1
	if resource_data.def == 0 :
		zero+= 1	
	#if resource_data.arm == 0 :
	zero+= 1	
	if resource_data.hp == 0 :
		zero += 1	
	if zero == 3 and resource_data.atk > 0 :
		$PlusLabel.text = str(resource_data.atk)
		$PlusLabel.label_settings = Global.red
	elif zero == 3 and resource_data.def > 0 :
		$PlusLabel.text = str(resource_data.def)
		$PlusLabel.label_settings = Global.blue
	#elif zero == 3 and resource_data.arm > 0 :
		#$PlusLabel.text = str(resource_data.arm)
		#$PlusLabel.label_settings = Global.green
	elif zero == 3 and resource_data.hp > 0 :
		$PlusLabel.text = str(resource_data.hp)
		$PlusLabel.label_settings = Global.green
	else :
		$PlusLabel.text = ""
		
func _on_body_entered(player: Node2D) -> void:
	if player.name == "Player" and Global.game_status == "run":
		Global.atk += resource_data.atk
		Global.def += resource_data.def
		Global.hp += resource_data.hp
		Global.ykey += resource_data.ykey
		Global.bkey += resource_data.bkey
		Global.rkey += resource_data.rkey	
		player.position = snapped(player.position,Global.cell_size)
		if player.click_run_times == 0 :
			player.run_times[player.current_dir] = 0
		self.queue_free()
		if self.animation in anim_atk :
			player.atkanim.visible = true
			player.atkanim.play("atk")
		elif self.animation in anim_def :
			player.defanim.visible = true
			player.defanim.play("def")
