extends Node2D

class_name PlayerControl

#signals
signal do_move_player1(input_vector)
signal do_move_player2(input_vector)

@export var player1_body: CharacterBody2D
@export var player2_body: CharacterBody2D
@onready var player: CharacterBody2D 

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 100

enum {
	MOVE
}

var state_player1 = MOVE
var state_player2 = MOVE

var input_vector_player1
var input_vector_player2

var last_direction_player1
var last_direction_player2

func _physics_process(delta: float) -> void:
	# 1st player (keyboards rows)
	match state_player1:
		MOVE:
			move_state_player1(delta)
	# 2nd player (WASD)
	match state_player2:
		MOVE:
			move_state_player2(delta)
			
func move_state_player1(delta):
	input_vector_player1 = Vector2.ZERO
	input_vector_player1.x = Input.get_axis("Left", "Right")
	input_vector_player1.y = Input.get_axis("Up", "Down")
	input_vector_player1 = input_vector_player1.normalized()
	
	if input_vector_player1 != Vector2.ZERO:
		do_move_player1.emit(input_vector_player1)
		player1_body.velocity = player1_body.velocity.move_toward(input_vector_player1 * MAX_SPEED, ACCELERATION * delta)
		last_direction_player1 = input_vector_player1
	else:
		player1_body.velocity = player1_body.velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	player1_body.move_and_slide()

func move_state_player2(delta):
	input_vector_player2 = Vector2.ZERO
	input_vector_player2.x = Input.get_axis("A", "D")  # Controles WASD
	input_vector_player2.y = Input.get_axis("W", "S")
	input_vector_player2 = input_vector_player2.normalized()
	
	if input_vector_player2 != Vector2.ZERO:
		do_move_player2.emit(input_vector_player2)
		player2_body.velocity = player2_body.velocity.move_toward(input_vector_player2 * MAX_SPEED, ACCELERATION * delta)
		last_direction_player2 = input_vector_player2
	else:
		player2_body.velocity = player2_body.velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	player2_body.move_and_slide()
	
