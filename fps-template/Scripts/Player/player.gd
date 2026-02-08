class_name Player extends CharacterBody3D

var mouse_sens := 0.001

@export var speed := 10.0
@export var gravity := -20.0
@export var jump_impulse := 10.0

@export var neck: Node3D
@export var camera: Camera3D

const SPEED = 10.0
const JUMP_VELOCITY = 7

@onready var is_paused = false


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_cancel") and not is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		is_paused = true
	elif Input.is_action_just_released("ui_cancel") and is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		is_paused = false


func _physics_process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x * mouse_sens)
		camera.rotate_x(-event.relative.y * mouse_sens)
		
		camera.rotation.x = clamp(
		camera.rotation.x,
		deg_to_rad(-90),
		deg_to_rad(90)
	)
