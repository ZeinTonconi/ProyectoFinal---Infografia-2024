extends RigidBody2D

@export_category("Movement")
@export var move_right_force := Vector2(25, 0)
@export var move_left_force := Vector2(-25, 0)
@export var move_speed_max := 50.0
@export var jump_force := Vector2(0, -500)

@export_category("Wall Grab")
@export var grab_force := 100.0
@export var grab_duration := 8.0
@export var sliding_force := Vector2(0, 20)

@export_category("Player")
@export var isPlayer1 := true

@onready var ray_right_foot: RayCast2D = $right_ray_foot
@onready var ray_left_foot: RayCast2D = $left_ray_foot
@onready var left_ray_wall: RayCast2D = $left_ray_wall
@onready var right_ray_wall: RayCast2D = $right_ray_wall
@onready var grab_timer: Timer = $GrabTimer

var actions := {
	"right": "",
	"left": "",
	"up": "",
	"grab": ""
}

var state_machine: StateMachine
var current_state: State

func _ready() -> void:
	setup_grab_timer()
	setup_actions()
	setup_state_machine()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	current_state.update(state)

func setup_grab_timer() -> void:
	if not has_node("GrabTimer"):
		grab_timer = Timer.new()
		grab_timer.name = "GrabTimer"
		add_child(grab_timer)
	grab_timer.one_shot = true
	grab_timer.wait_time = grab_duration

func setup_actions() -> void:
	var player_suffix = "1" if isPlayer1 else "2"
	actions = {
		"right": "Right player " + player_suffix,
		"left": "Left player " + player_suffix,
		"up": "Up player " + player_suffix,
		"grab": "Grab wall " + player_suffix
	}

func setup_state_machine() -> void:
	state_machine = StateMachine.new(self)
	state_machine.add_state("normal", NormalState.new())
	state_machine.add_state("wall_grab", WallGrabState.new())
	state_machine.set_state("normal")
	
#func is_on_floor() -> bool:
	#return ray_left_foot.is_colliding() or ray_right_foot.is_colliding()

func is_on_wall() -> bool:
	return left_ray_wall.is_colliding() or right_ray_wall.is_colliding()

class StateMachine:
	var player: RigidBody2D
	var states := {}
	var current_state: State

	func _init(_player: RigidBody2D) -> void:
		player = _player

	func add_state(name: String, state: State) -> void:
		states[name] = state
		state.player = player

	func set_state(name: String) -> void:
		if current_state:
			current_state.exit()
		current_state = states[name]
		player.current_state = current_state
		current_state.enter()

class State:
	var player: RigidBody2D

	func enter() -> void:
		pass

	func exit() -> void:
		pass

	func update(state: PhysicsDirectBodyState2D) -> void:
		pass

class NormalState extends State:
	func update(state: PhysicsDirectBodyState2D) -> void:
		handle_movement(state)
		check_for_wall_grab(state)

	func handle_movement(state: PhysicsDirectBodyState2D) -> void:
		if abs(state.linear_velocity.x) < 0.1:
			state.linear_velocity.x = 0
		if Input.is_action_pressed(player.actions["left"]) and state.linear_velocity.x > -player.move_speed_max:
			state.apply_central_impulse(player.move_left_force)
		if Input.is_action_pressed(player.actions["right"]) and state.linear_velocity.x < player.move_speed_max:
			state.apply_central_impulse(player.move_right_force)
		if Input.is_action_just_pressed(player.actions["up"]) and (player.ray_left_foot.is_colliding() or player.ray_right_foot.is_colliding()):
			state.apply_central_impulse(player.jump_force)

	func check_for_wall_grab(state: PhysicsDirectBodyState2D) -> void:
		if (player.left_ray_wall.is_colliding() or player.right_ray_wall.is_colliding()) and Input.is_action_just_pressed(player.actions["grab"]):
			player.state_machine.set_state("wall_grab")

class WallGrabState extends State:
	var grab_position: Vector2

	func enter() -> void:
		grab_position = player.global_position
		player.grab_timer.start()

	func update(state: PhysicsDirectBodyState2D) -> void:
		if player.ray_left_foot.is_colliding() or player.ray_right_foot.is_colliding() or not player.is_on_wall():
			player.state_machine.set_state("normal")
			return
		if not player.is_on_wall():
			player.state_machine.set_state("normal")
			return
		state.transform.origin = grab_position
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		
		grab_position += player.sliding_force * state.step
		
		if not Input.is_action_pressed(player.actions["grab"]) or player.grab_timer.is_stopped():
			player.state_machine.set_state("normal")

	func exit() -> void:
		grab_position = Vector2.ZERO
		player.linear_velocity = Vector2.ZERO
		player.angular_velocity = 0
