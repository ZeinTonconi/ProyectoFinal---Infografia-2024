extends State

var grab_position: Vector2

func enter() -> void:
	grab_position = player.global_position
	player.grab_timer.start()
	player.animation_tree.set("parameters/animation/animation", "Wall Grab")

func update(state: PhysicsDirectBodyState2D) -> void:
	if player.ray_left_foot.is_colliding() or player.ray_right_foot.is_colliding() or not player.is_on_wall():
		player.state_machine.set_state(IDLE)
		return
	if not player.is_on_wall():
		player.state_machine.set_state(IDLE)
		return
	state.transform.origin = grab_position
	state.linear_velocity = Vector2.ZERO
	state.angular_velocity = 0
	
	grab_position += player.sliding_force * state.step
	
	if not Input.is_action_pressed(player.actions["grab"]) or player.grab_timer.is_stopped():
		player.state_machine.set_state(IDLE)

func exit() -> void:
	grab_position = Vector2.ZERO
	player.linear_velocity = Vector2.ZERO
	player.angular_velocity = 0
	player.animation_tree.set("parameters/animation/animation", "Idle")
