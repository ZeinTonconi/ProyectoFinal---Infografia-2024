extends State

var onAir = false

func update(state: PhysicsDirectBodyState2D) -> void:
	handle_movement(state)
	check_for_wall_grab(state)
	animate_movement(state)
	
func handle_movement(state: PhysicsDirectBodyState2D) -> void:
		
	if Input.is_action_pressed(player.actions["left"]) and state.linear_velocity.x > -player.move_speed_max:
		state.apply_central_impulse(player.move_left_force)
		
	if Input.is_action_pressed(player.actions["right"]) and state.linear_velocity.x < player.move_speed_max:
		state.apply_central_impulse(player.move_right_force)
	
	if onAir and (player.ray_left_foot.is_colliding() or player.ray_right_foot.is_colliding()):
		onAir = false
		state_machine.set_state(IDLE)
	
	if Input.is_action_pressed(player.actions["up"]) and (player.ray_left_foot.is_colliding() or player.ray_right_foot.is_colliding()):
		state.apply_central_impulse(player.jump_force)
		onAir = true
		

func check_for_wall_grab(state: PhysicsDirectBodyState2D) -> void:
	if (player.left_ray_wall.is_colliding() or player.right_ray_wall.is_colliding()) and Input.is_action_just_pressed(player.actions["grab"]):
		state_machine.set_state(WALL_GRAB)
	else:
		if player.left_ray_wall.is_colliding():
			state.linear_velocity.x = max(0, state.linear_velocity.x)
		if player.right_ray_wall.is_colliding():
			state.linear_velocity.x = min(0, state.linear_velocity.x)
	

func animate_movement(state: PhysicsDirectBodyState2D) -> void:
	player.animation_tree.set("parameters/Jump/blend_position",state.linear_velocity.y)
	player.state_animation.travel("Jump")
