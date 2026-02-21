class_name WeaponManager extends Node3D


@export var weapon_res: WeaponRes
@export var weapon_ray: RayCast3D
@export var fire_rate_timer: Timer

var is_shooting: bool
var player: Player


func _ready() -> void:
	setup_weapon()


func connect_player(player_node: Player):
	player = player_node


func setup_weapon():
	weapon_ray.target_position.z = -weapon_res.range


func weapon_action():
	if weapon_res.is_melee:
		melee()
	else:
		shoot()


func melee():
	var collider = weapon_ray.get_collider()
	print(collider)
	if collider is CharacterBody3D:
		var enemy_player = collider as Player
		do_damage_to_player(enemy_player)


func shoot():
	start_fire_rate_timer()
	var collider = weapon_ray.get_collider()
	print(collider)
	if collider is CharacterBody3D:
		var enemy_player = collider as Player
		do_damage_to_player(enemy_player)


func do_damage_to_player(enemy_player: Player):
	enemy_player.request_damage.rpc_id(
		enemy_player.get_multiplayer_authority(), 
		multiplayer.get_unique_id(),
		weapon_res.damage)


func swap_out_weapon(new_weapon_res: WeaponRes):
	weapon_res = new_weapon_res
	setup_weapon()
	player.set_weapon_name.emit()


func start_fire_rate_timer():
	fire_rate_timer.one_shot = true
	fire_rate_timer.start(weapon_res.fire_rate)
