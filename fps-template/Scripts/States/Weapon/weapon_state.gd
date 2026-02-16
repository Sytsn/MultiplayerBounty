class_name WeaponState extends State

const IDLE = "Idle"

var weapon_manager: WeaponManager


func _ready() -> void:
	await owner.ready
	weapon_manager = owner as WeaponManager
	assert(weapon_manager != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
