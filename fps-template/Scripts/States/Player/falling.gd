extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass
func physics_update(delta: float) -> void:
	if !player.is_multiplayer_authority() && player.is_multiplayer: return

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	player.air_move_player(delta, input_dir)

	if player.is_on_floor():
		if is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(WALKING)
