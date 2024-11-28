extends CharacterBody2D
var SPEED : int = 4 #必须大于等于4

var map_node : Node2D
var current_dir : String = "null"
var run_queue : Array[String] = [] 
var current_path : Array[Vector2i]
var map_click_position : Vector2i
var map_player_position : Vector2i
var click_run_times: int = 0
@onready var atkanim : AnimatedSprite2D = $atkability
@onready var defanim : AnimatedSprite2D = $defability

var direction : Dictionary = {
	"right": Vector2(32.0 / SPEED,0),
	"left": Vector2(-32.0 / SPEED,0),
	"up" : Vector2(0,-32.0 / SPEED),
	"down" : Vector2(0, 32.0 / SPEED),
}

var redirection : Dictionary = {
	Vector2i(1,0) : "right",
	Vector2i(-1,0) : "left",
	Vector2i(0,-1) : "up",
	Vector2i(0,1) : "down",
	Vector2i(1,1) : "up",
	Vector2i(1,-1) : "down",
	Vector2i(-1,1) : "up",
	Vector2i(-1,-1) : "down",
}

var run_times : Dictionary = {
	"right": 0,
	"left": 0,
	"down":0,
	"up":0,
}

func _process(delta: float) -> void:
	if Global.game_status != "run" :
		return
	if click_run_times > 0 and Input.is_action_pressed("move") :		
		current_path.clear()
		run_times.right = 0
		run_times.left = 0
		run_times.up = 0
		run_times.down = 0
		self.position = snapped(self.position,Global.cell_size)
		click_run_times = 0;
	
	if current_path.is_empty() == true and click_run_times == 0:
		move_delta()
		move(delta)
	elif click_run_times > 0:
		click_run_times -= 1
		move(delta)
	else :
		current_dir = redirection[current_path.front() - map_player_position]
		run_queue.push_back(current_dir)
		while current_path.is_empty() == false and redirection[current_path.front() - map_player_position] == current_dir :
			run_times[current_dir] += SPEED
			click_run_times += SPEED
			map_player_position = current_path.front()
			current_path.pop_front()	
		run_times[current_dir] -= 1
		click_run_times -= 1
				
func _unhandled_input(event: InputEvent) -> void:
	if Global.game_status != "run" :
		return
	if event.is_action_pressed("mouse_left_click") :
		if click_run_times > 0 :
			current_path.clear()
			run_times.right = 0
			run_times.left = 0
			run_times.up = 0
			run_times.down = 0
			self.position = snapped(self.position,Global.cell_size)
			click_run_times = 0;
			
		map_click_position = map_node.tmap.local_to_map(get_global_mouse_position()) - Vector2i(5,0)
		Global.click_effect(map_click_position + Vector2i(5,0))
		map_player_position = map_node.tmap.local_to_map(self.position)
		run_times.right = 0
		run_times.left = 0
		run_times.down = 0
		run_times.up = 0
		self.position = snapped(self.position,Global.cell_size)
		
		if map_node.is_point_walkable(map_click_position) :
			current_path = map_node.astar.get_id_path(
				map_player_position,
				map_click_position
			).slice(1)
		
func move_delta() -> void:  
	if Input.is_action_just_pressed("ui_right") :
		run_queue.push_back("right")
	if Input.is_action_just_pressed("ui_left") :
		run_queue.push_back("left")
	if Input.is_action_just_pressed("ui_up") :
		run_queue.push_back("up")
	if Input.is_action_just_pressed("ui_down") :
		run_queue.push_back("down")
	
	if Input.is_action_pressed("ui_right") :
		run_times.right += SPEED
	if Input.is_action_pressed("ui_left") :
		run_times.left += SPEED
	if Input.is_action_pressed("ui_up") :
		run_times.up += SPEED
	if Input.is_action_pressed("ui_down") :
		run_times.down += SPEED
		
	if Input.is_action_just_released("ui_right") :
		run_times.right %= SPEED
	if Input.is_action_just_released("ui_left") :
		run_times.left %= SPEED
	if Input.is_action_just_released("ui_up") :
		run_times.up %= SPEED
	if Input.is_action_just_released("ui_down") :
		run_times.down %= SPEED

func move(delta: float) :
	if run_queue.is_empty() :
		self.position = snapped(self.position,Global.cell_size)
		self.velocity = Vector2(0,0);
		play_anim(false)
		return
	var nowrun = run_queue.front()
	if run_times[nowrun] <= 0 : 
		self.position = snapped(self.position,Global.cell_size)
		run_queue.pop_front()
		return
	if run_times[nowrun] > 0:
		current_dir = nowrun
		play_anim(true)
		run_times[nowrun] -= 1		
	self.velocity = direction[nowrun] / delta
	move_and_slide()
	var check = get_last_slide_collision()
	if check != null and check.get_collider() != null :
		if  check.get_collider().get_name() == "enable_broken" and click_run_times > 0:
			run_times[nowrun] += 1
			click_run_times += 1
	
		
func play_anim(movement : bool):
	var dir = current_dir
	var anim = $walk;
	if dir == "right" :
		anim.flip_h = false
		if movement == true :
			anim.play("side_walk")
		else :
			anim.play("side_idle")
	if dir == "left" :
		anim.flip_h = true
		if movement == true :
			anim.play("side_walk")
		else :
			anim.play("side_idle")
	if dir == "up" :
		anim.flip_h = false
		if movement == true :
			anim.play("back_walk")
		else :
			anim.play("back_idle")
	if dir == "down" :
		anim.flip_h = false
		if movement == true :
			anim.play("front_walk")
		else :
			anim.play("front_idle")	


func _on_atkability_animation_finished() -> void:
	atkanim.visible = false

func _on_defability_animation_finished() -> void:
	defanim.visible = false
