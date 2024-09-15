extends RigidBody2D

@export_category("Movement")
@export var move_right_force := Vector2(50, 0)
@export var move_left_force := Vector2(-50, 0)
@export var move_speed_max := 200.0
@export var jump_force := Vector2(0, -250)
@export var pull_force = 33

@export_category("Wall Grab")
@export var grab_force := 100.0
@export var grab_duration := 8.0
@export var sliding_force := Vector2(0, 20)

@export_category("Player")
@export var isPlayer1 := true
@export var other_player: RigidBody2D = null

@onready var ray_right_foot: RayCast2D = $right_ray_foot
@onready var ray_left_foot: RayCast2D = $left_ray_foot
@onready var left_ray_wall: RayCast2D = $left_ray_wall
@onready var right_ray_wall: RayCast2D = $right_ray_wall
@onready var grab_timer: Timer = $GrabTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_animation = $AnimationTree.get("parameters/playback")
@onready var state_machine: Node2D = $StateMachine
@onready var left_wall_area: Area2D = $left_wall_area
@onready var right_wall_area: Area2D = $right_wall_area

var actions := {
	"right": "",
	"left": "",
	"up": "",
	"grab": "",
	"crouch": "",
	"pull": ""
}

var current_state: State

var is_hook = false
var flip = 0

func _ready() -> void:
	setup_grab_timer()
	setup_actions()
	setup_state_machine()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	current_state.update(state)
	$Sprite2D.flip_h = flip

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
		"grab": "Grab wall " + player_suffix,
		"crouch": "Down player " + player_suffix,
		"pull": "Pull player " + player_suffix
	}

func setup_state_machine() -> void:
	state_machine.init_states()

func is_on_wall() -> bool:
	return left_wall_area.has_overlapping_bodies() or right_wall_area.has_overlapping_bodies()

func pull_other_player():
	other_player.pull_me(global_position)
	
func pull_me(position):
	var dir = global_position.direction_to(position)
	apply_central_impulse(dir*pull_force)

func is_on_floor():
	return $Area2D.has_overlapping_bodies()
