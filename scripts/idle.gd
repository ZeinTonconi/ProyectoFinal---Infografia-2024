extends State

func update(state: PhysicsDirectBodyState2D) -> void:
	handle_movement(state)
	check_for_wall_grab(state)
	animate_movement()

func handle_movement(state: PhysicsDirectBodyState2D) -> void:
	if Input.is_action_pressed(player.actions["left"]) or Input.is_action_pressed(player.actions["right"]):
		state_machine.set_state(MOVE)
	if Input.is_action_pressed(player.actions["up"]) and player.is_on_floor():
		state_machine.set_state(JUMP)
		
	if Input.is_action_pressed(player.actions["crouch"]):
		state_machine.set_state(CROUCH)
		
	if Input.is_action_pressed(player.actions["pull"]):
		print("PULL")
		state_machine.set_state(PULL)

func check_for_wall_grab(state: PhysicsDirectBodyState2D) -> void:
	if (player.left_ray_wall.is_colliding() or player.right_ray_wall.is_colliding()) and Input.is_action_just_pressed(player.actions["grab"]):
		state_machine.set_state(WALL_GRAB)

func animate_movement():
	player.state_animation.travel("Idle")
