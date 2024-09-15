extends State

func update(state: PhysicsDirectBodyState2D) -> void:
	handle_movement(state)
	check_for_wall_grab(state)
	animate_movement(state)

func handle_movement(state: PhysicsDirectBodyState2D) -> void:
	if abs(state.linear_velocity.x) < 0.1:
		state.linear_velocity.x = 0
		state_machine.set_state(IDLE)
		
	if Input.is_action_pressed(player.actions["left"]) and state.linear_velocity.x > -player.move_speed_max:
		state.apply_central_impulse(player.move_left_force)
		player.flip = 1
		
	if Input.is_action_pressed(player.actions["right"]) and state.linear_velocity.x < player.move_speed_max:
		state.apply_central_impulse(player.move_right_force)
		player.flip = 0
		
	if Input.is_action_just_pressed(player.actions["up"]) and player.is_on_floor():
		state_machine.set_state(JUMP)
	
	if Input.is_action_just_pressed(player.actions["crouch"]):
		state_machine.set_state(CROUCH)
		
	if Input.is_action_pressed(player.actions["pull"]):
		state_machine.set_state(PULL)

func check_for_wall_grab(state: PhysicsDirectBodyState2D) -> void:
	if player.is_on_wall() and Input.is_action_just_pressed(player.actions["grab"]):
		state_machine.set_state(WALL_GRAB)
	else:
		if player.left_ray_wall.is_colliding():
			state.linear_velocity.x = max(0, state.linear_velocity.x)
		if player.right_ray_wall.is_colliding():
			state.linear_velocity.x = min(0, state.linear_velocity.x)

func animate_movement(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity.x > 0:
		player.state_animation.travel("Run")
	elif state.linear_velocity.x < 0:
		player.state_animation.travel("Run")
