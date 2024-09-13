extends RigidBody2D

@export var move_right_force = Vector2(25,0)
@export var move_left_force = Vector2(-25,0)
@export var move_speed_max = 10

@export var jump_force = Vector2(0,-500)

@export var isPlayer1 = true
@onready var ray_right_foot = $right_ray_foot
@onready var ray_left_foot = $left_ray_foot

var actions

func _ready() -> void:
	if isPlayer1:
		actions = [
			"Right player 1",
			"Left player 1",
			"Up player 1"
		]
	else:
		actions = [
			"Right player 2",
			"Left player 2",
			"Up player 2"
		]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed(actions[1]) and self.linear_velocity.x < move_speed_max:
		self.apply_impulse(move_left_force, Vector2(0,0))
	if Input.is_action_pressed(actions[0]) and self.linear_velocity.x > -move_speed_max:
		self.apply_impulse(move_right_force, Vector2(0,0))
	if Input.is_action_just_pressed(actions[2]) and (ray_left_foot.is_colliding() or ray_right_foot.is_colliding()):
		self.apply_impulse(jump_force, Vector2(0,0))
		
