extends Interactable

@export var res_path: String

func interact(player: Player = null):
	var weapon_res = load(res_path)
	player.weapon_manager.swap_out_weapon(weapon_res)
