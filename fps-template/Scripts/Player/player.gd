class_name Player extends CharacterBody3D


@export var player_res: PlayerRes
@export var neck: Node3D
@export var camera: Camera3D
@export var collider: CollisionShape3D
@export var mesh: MeshInstance3D
@export var is_multiplayer: bool = true
@export var crouch_shape_cast: ShapeCast3D
@export var health_res: HealthRes

var health: Health
var is_paused = false
var is_crouching = false
var exiting_crouching = false
var is_dead = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func health_setup():
	health = Health.new(health_res.max_health, health_res.min_health, health_res.heal_rate, health_res.heal_rate)
	health.dead.connect(_on_death)


#region Player Movement

func move_player(delta: float, input_dir: Vector2, speed: float):
	var wish_dir = neck.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	var cur_speed_in_wish_dir = velocity.dot(wish_dir)
	var add_speed_till_cap = speed - cur_speed_in_wish_dir

	if add_speed_till_cap > 0:
		var accel_speed = player_res.air_accel * delta * speed
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wish_dir

	var control = max(velocity.length(), player_res.ground_decel)
	var drop = control * player_res.ground_friction * delta
	var new_speed = max(velocity.length() - drop, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
	velocity *= new_speed
	
	move_and_slide()


func air_move_player(delta: float, input_dir: Vector2):
	velocity.y += player_res.gravity * delta
	var wish_dir = neck.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	
	var cur_speed_in_wish_dir = velocity.dot(wish_dir)
	var capped_speed = min((player_res.air_move_speed * wish_dir).length(), player_res.air_cap)
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = player_res.air_accel * player_res.air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wish_dir
	
	move_and_slide()


func slide_player(delta: float, input_dir: Vector2, speed: float):
	var wish_dir = neck.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	var cur_speed_in_wish_dir = velocity.dot(wish_dir)
	var add_speed_till_cap = speed - cur_speed_in_wish_dir

	if add_speed_till_cap > 0:
		var accel_speed = player_res.slide_accel * delta * speed
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wish_dir

	var control = max(velocity.length(), player_res.slide_decel)
	var drop = control * player_res.slide_friction * delta
	var new_speed = max(velocity.length() - drop, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
	velocity *= new_speed
	
	move_and_slide()


func stop_player(delta: float):
	velocity.y += player_res.gravity * delta
	velocity.x = move_toward(velocity.x, 0, player_res.move_speed)
	velocity.z = move_toward(velocity.z, 0, player_res.move_speed)
	move_and_slide()


#endregion


#region Crouching

func enter_crouch_ground():
	is_crouching = true
	collider.scale.y = collider.scale.y / 2
	neck.position.y -=  .6
	velocity.y += -50.0
	move_and_slide()


func  enter_crouch_air():
	collider.scale.y = collider.scale.y / 2
	neck.position.y -=  .6

func exit_crouch():
	is_crouching = false
	collider.scale.y = collider.scale.y * 2
	neck.position.y += .6
	exiting_crouching = false


#endregion


func _on_death():
	is_dead = true
