extends Node2D

class_name StateMachine

var states := {}
var current_state: State = null
@onready var state = $State
@onready var move = $Move
@onready var idle = $Idle
@onready var grab = $Grab
@onready var crouch = $Crouch
@onready var jump = $Jump
@onready var pulling = $Pulling

@export var player: RigidBody2D = null


func init_states():
	states[state.MOVE] = move
	move.player = player
	
	states[state.IDLE] = idle
	idle.player = player
	
	states[state.WALL_GRAB] = grab
	grab.player = player
	
	states[state.CROUCH] = crouch
	crouch.player = player

	states[state.JUMP] = jump
	jump.player = player
	
	states[state.PULL] = pulling
	pulling.player = player
		
	set_state(state.IDLE)
	

func add_state(name: int, state: State) -> void:
	states[name] = state
	state.player = player

func set_state(name: int) -> void:
	#if current_state:
		#current_state.exit()
	current_state = states[name]
	player.current_state = current_state
	current_state.enter()
