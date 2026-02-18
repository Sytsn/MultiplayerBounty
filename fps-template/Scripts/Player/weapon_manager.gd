class_name WeaponManager extends Node3D


@export var weapon_res: WeaponRes
@export var weapon_ray: RayCast3D
var player: Player


func _ready() -> void:
	setup_weapon()


func connect_player(player_node: Player):
	player = player_node
	print(player)


func setup_weapon():
	weapon_ray.target_position.z = -weapon_res.range


func weapon_action():
	if weapon_res.is_melee:
		melee()


func melee():
	var collider = weapon_ray.get_collider()
	print(collider)
	if collider is CharacterBody3D:
		var enemy_player = collider as Player
		do_damage_to_player(enemy_player)


func do_damage_to_player(enemy_player: Player):
	enemy_player.request_damage.rpc_id(
		enemy_player.get_multiplayer_authority(), 
		multiplayer.get_unique_id(),
		25)
