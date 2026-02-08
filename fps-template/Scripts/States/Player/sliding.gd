extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	print("slide")
	#player.animation_player.play("run")
	pass


func physics_update(delta: float) -> void:
	if !player.is_multiplayer_authority() && player.is_multiplayer: return
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	player.slide_player(delta, input_dir, player.player_res.sprint_speed)
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump") or (player.player_res.auto_bhop and Input.is_action_pressed("jump")):
		finished.emit(JUMPING)
	elif is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0) && player.velocity == Vector3.ZERO:
		finished.emit(IDLE)
