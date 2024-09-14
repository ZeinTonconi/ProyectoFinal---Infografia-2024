extends Node2D
class_name State

var player: RigidBody2D

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
