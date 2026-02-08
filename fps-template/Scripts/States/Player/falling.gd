extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass
func physics_update(delta: float) -> void:
	if !player.is_multiplayer_authority() && player.is_multiplayer: return

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	player.move_player(input_dir, player.player_res.air_speed)
	player.velocity.y += player.player_res.gravity * delta
	player.move_and_slide()

	if player.is_on_floor():
		if is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(WALKING)
