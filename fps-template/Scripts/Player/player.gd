class_name Player extends CharacterBody3D


@export var player_res: PlayerRes
@export var neck: Node3D
@export var camera: Camera3D
@export var collider: CollisionShape3D
@export var mesh: MeshInstance3D
@export var is_multiplayer: bool = true
@export var crouch_shape_cast: ShapeCast3D
@export var health_res: HealthRes
@export var interact_ray: RayCast3D
@export var weapon_manager: WeaponManager

var health: Health
var is_paused = false
var is_crouching = false
var exiting_crouching = false
var is_dead = false
var cur_interactable = null

signal set_health(new_health: float)
signal set_weapon_name


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	if is_multiplayer_authority():
		camera.current = true
		weapon_connection_setup()
	health_setup()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	if interact_ray.is_colliding() and cur_interactable == null:
		var res = interact_ray.get_collider()
		if res is Node3D:
			cur_interactable = res.get_parent()
			print(cur_interactable)
	elif !interact_ray.is_colliding() and cur_interactable != null:
		cur_interactable = null


#region Setup

func health_setup():
	health = Health.new(health_res.max_health, health_res.min_health, health_res.heal_rate, health_res.heal_rate)
	health.dead.connect(_on_death)
	health.damage_taken.connect(_on_damage_taken)


func weapon_connection_setup():
	weapon_manager.connect_player(self)
	set_weapon_name.emit()


#endregion


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
	if exiting_crouching:
		return
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


#region Health

@rpc("any_peer", "call_local", "reliable")
func request_damage(attacker_id: int, damage: int):
	if not is_multiplayer_authority(): return  # Only authority processes
	
	# Server/authority applies damage
	health._take_damage(damage)
	print("Took ", damage, " damage from ", attacker_id)


func _on_damage_taken(new_health: float):
	print("curr_health: " + str(health.curr_health))
	set_health.emit(new_health)


func _on_death():
	print("Dead")
	set_health.emit(health.min_health)
	is_dead = true

#endregion
