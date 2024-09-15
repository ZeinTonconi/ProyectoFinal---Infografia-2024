extends State

func enter() -> void:
	player.mass = 200
	player.state_animation.travel("Crouch")
	player.is_crouch = true

func update(state: PhysicsDirectBodyState2D) -> void:
	player.state_animation.travel("Crouch")
	if not Input.is_action_pressed(player.actions["crouch"]):
		exit()
		state_machine.set_state(IDLE)

func exit() -> void:
	player.mass = 1
	player.state_animation.travel("Idle")
	player.is_crouch = false
