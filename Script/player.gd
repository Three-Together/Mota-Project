extends CharacterBody2D

const SPEED = 16
const cell_size=Vector2(16,16)
var current_dir = "none"
var runqueue = []
var direction = {
	"right": Vector2(16.0 / SPEED,0),
	"left": Vector2(-16.0 / SPEED,0),
	"up" : Vector2(0,-16.0 / SPEED),
	"down" : Vector2(0, 16.0 / SPEED),
}
var runtimes = {
	"right":0,
	"left":0,
	"down":0,
	"up":0,
}
@onready var world = self.get_parent().get_parent()

func _ready() -> void:
	self.position = Vector2(160,160);

func _process(delta: float) -> void:
	move_delta()
	move(delta)

func move_delta() -> void:  
	if Input.is_action_just_pressed("ui_right") :
		runqueue.push_back("right")
	if Input.is_action_just_pressed("ui_left") :
		runqueue.push_back("left")
	if Input.is_action_just_pressed("ui_up") :
		runqueue.push_back("up")
	if Input.is_action_just_pressed("ui_down") :
		runqueue.push_back("down")
	
	if Input.is_action_pressed("ui_right") :
		runtimes["right"] += SPEED
	if Input.is_action_pressed("ui_left") :
		runtimes["left"] += SPEED
	if Input.is_action_pressed("ui_up") :
		runtimes["up"] += SPEED
	if Input.is_action_pressed("ui_down") :
		runtimes["down"] += SPEED
		
	if Input.is_action_just_released("ui_right") :
		runtimes["right"] %= SPEED
	if Input.is_action_just_released("ui_left") :
		runtimes["left"] %= SPEED
	if Input.is_action_just_released("ui_up") :
		runtimes["up"] %= SPEED
	if Input.is_action_just_released("ui_down") :
		runtimes["down"] %= SPEED

func move(delta: float) :
	if runqueue.is_empty() :
		self.position = snapped(self.position,cell_size)
		self.velocity = Vector2(0,0);
		play_anim(false)
		return
	var nowrun = runqueue.front()
	if runtimes[nowrun] <= 0 : 
		self.position = snapped(self.position,cell_size)
		runqueue.pop_front()
		return
	if runtimes[nowrun] > 0:
		current_dir = nowrun
		play_anim(true)
		runtimes[nowrun] -= 1		
	self.velocity = direction[nowrun] / delta
	move_and_slide()
				   
		
func play_anim(movement : bool):
	var dir = current_dir
	var anim = $AnimatedSprite2D;
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
		
func pickup(Plus : Dictionary) -> void :
	Global.PlayerStatus["attack"] += Plus["attack"]
	Global.PlayerStatus["defense"] += Plus["defense"]
	Global.PlayerStatus["hp"] += Plus["hp"]
	world.updateStatus()
	
