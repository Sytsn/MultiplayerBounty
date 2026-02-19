extends Interactable

@export var res_path: String
var weapon_res: WeaponRes
var weapon_label: Label3D


func interact(player: Player = null):
	player.weapon_manager.swap_out_weapon(weapon_res)


func interact_ready():
	weapon_res = load(res_path)
	weapon_label = %WeaponName
	weapon_label.text = weapon_res.weapon_name
