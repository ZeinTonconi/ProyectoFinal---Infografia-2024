extends CharacterBody2D

@export var isPlayer1 = true
#@export var other_character: CharacterBody2D

var SPEED = 150
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var JUMP_SPEED = -600
var MAX_DISTANCE = 50 
var PULL_FORCE = 500

var input_vector

func _ready() -> void:
	if isPlayer1:
		input_vector = [
			"Right player 1",
			"Left player 1",
			"Up player 1"
		]
	else:
		input_vector = [
			"Right player 2",
			"Left player 2",
			"Up player 2"
		]

func _physics_process(delta: float) -> void:
	var right = Input.get_action_strength(input_vector[0]) - Input.get_action_strength(input_vector[1])
	velocity.x = right * SPEED
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed(input_vector[2]) and is_on_floor():
		velocity.y = JUMP_SPEED  
		
	move_and_slide()
	#
	#if other_character:
		#var distance = position.distance_to(other_character.position)
		#if distance > MAX_DISTANCE:
			#var pull_direction = (other_character.position - position).normalized()
			#velocity += pull_direction * PULL_FORCE * delta
			#other_character.velocity -= pull_direction * PULL_FORCE * delta
	#else:
		#print("other_character no está asignado")
