extends State

func update(state) -> void:
	handle_input(state)
	handle_animation(state)
	
func handle_input(state) -> void:
	if Input.is_action_pressed(player.actions["pull"]):
		if player.other_player.is_hook:
			player.pull_me(player.other_player.global_position)
		else:
			player.pull_other_player()
	if Input.is_action_just_released(player.actions["pull"]):
		state_machine.set_state(IDLE)
		
func handle_animation(state):
	player.state_animation.travel("Pulling")
