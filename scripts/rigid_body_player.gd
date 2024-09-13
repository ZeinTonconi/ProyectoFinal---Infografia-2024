extends RigidBody2D

@export var move_right_force = Vector2(25,0)
@export var move_left_force = Vector2(-25,0)
@export var move_speed_max = 10

@export var jump_force = Vector2(0,-500)
@export var grab_force = 100
@export var grab_duration = 8.0 #seconds

@export var isPlayer1 = true
@onready var ray_right_foot = $right_ray_foot
@onready var ray_left_foot = $left_ray_foot
@onready var left_ray_wall: RayCast2D = $left_ray_wall
@onready var right_ray_wall: RayCast2D = $right_ray_wall
@onready var grab_timer: Timer = Timer.new()
@onready var animation_tree: AnimationTree = $AnimationTree

var actions
var is_grabbing_wall = false

enum {
	IDLE,
	MOVE,
	CROUCH
}

var state = IDLE

func _ready() -> void:
	add_child(grab_timer)
	grab_timer.one_shot = true  
	grab_timer.wait_time = grab_duration 
	
	if isPlayer1:
		actions = [
			"Right player 1",
			"Left player 1",
			"Up player 1",
			"Grab wall 1", #P
			"Down player 1"
		]
	else:
		actions = [
			"Right player 2",
			"Left player 2",
			"Up player 2",
			"Grab wall 2", #Q
			"Down player 2"
		]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_grabbing_wall:
		self.linear_velocity = Vector2.ZERO
		self.angular_velocity = 0
		var other_player_path = "/root/Node2D/"
		if isPlayer1:
			other_player_path += "RigidBody2D2"
		else:
			other_player_path += "RigidBody2D"
		var other_player = get_node_or_null(other_player_path)
		if other_player:
			var direction_to_other = (other_player.position - self.position).normalized()
			var grab_direction = -direction_to_other * grab_force
			self.apply_impulse(grab_direction, Vector2.ZERO)
		if not Input.is_action_pressed(actions[3]) or grab_timer.is_stopped():
			is_grabbing_wall = false
		return
	if state == MOVE || state == IDLE: 	
		if Input.is_action_pressed(actions[1]) and self.linear_velocity.x < move_speed_max:
			self.apply_impulse(move_left_force, Vector2(0,0))
			
		if Input.is_action_pressed(actions[0]) and self.linear_velocity.x > -move_speed_max:
			self.apply_impulse(move_right_force, Vector2(0,0))
			
		if Input.is_action_just_pressed(actions[2]) and (ray_left_foot.is_colliding() or ray_right_foot.is_colliding()):
			self.apply_impulse(jump_force, Vector2(0,0))
			
		if (left_ray_wall.is_colliding() or right_ray_wall.is_colliding()) and Input.is_action_just_pressed(actions[3]):
			grab_wall()
	
	if Input.is_action_just_pressed(actions[4]):
		self.mass = 100
		state = CROUCH
	
	if Input.is_action_just_released(actions[4]):
		self.mass = 1
		state = MOVE
		
func grab_wall() -> void:
	is_grabbing_wall = true
	self.linear_velocity = Vector2.ZERO
	self.angular_velocity = 0
	grab_timer.start()
		
