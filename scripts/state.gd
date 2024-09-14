extends Node2D
class_name State

var player: RigidBody2D
@onready var state_machine: StateMachine = get_parent()

enum {
	IDLE,
	MOVE,
	CROUCH,
	WALL_GRAB
}

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(state: PhysicsDirectBodyState2D) -> void:
	pass
