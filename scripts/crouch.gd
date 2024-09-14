extends State

func enter() -> void:
	player.mass = 100
	player.animation_tree.set("parameters/animation/animation", "Crouch")

func update(state: PhysicsDirectBodyState2D) -> void:
	if not Input.is_action_pressed(player.actions["crouch"]):
		player.state_machine.set_state(MOVE)

func exit() -> void:
	player.mass = 1
	player.animation_tree.set("parameters/animation/animation", "Idle")
