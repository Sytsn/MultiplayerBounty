class_name WeaponState extends State

const IDLE = "Idle"

var weapon_manager: WeaponManager


func _ready() -> void:
	await owner.ready
	weapon_manager = owner as WeaponManager
	assert(weapon_manager != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")


func update(delta: float) -> void:
	action_inputs()


func action_inputs():
	if Input.is_action_just_pressed("action_1") or weapon_manager.is_shooting:
		if weapon_manager.weapon_res.is_full_auto and !weapon_manager.is_shooting:
			weapon_manager.is_shooting = true
		if weapon_manager.fire_rate_timer.time_left == 0:
			weapon_manager.weapon_action()
	if Input.is_action_just_released("action_1") and weapon_manager.weapon_res.is_full_auto:
		weapon_manager.is_shooting = false
