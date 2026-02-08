class_name Player extends CharacterBody3D


@export var player_res: PlayerRes
@export var neck: Node3D
@export var camera: Camera3D
@export var is_multiplayer: bool = true

var is_paused = false


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func move_player(input_dir: Vector2):
	var direction := (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * player_res.move_speed
		velocity.z = direction.z * player_res.move_speed 
	else:
		velocity.x = move_toward(velocity.x, 0, player_res.move_speed)
		velocity.z = move_toward(velocity.z, 0, player_res.move_speed)
	
	move_and_slide()


func stop_player(delta: float):
	velocity.y += player_res.gravity * delta
	velocity.x = move_toward(velocity.x, 0, player_res.move_speed)
	velocity.z = move_toward(velocity.z, 0, player_res.move_speed)
	move_and_slide()
