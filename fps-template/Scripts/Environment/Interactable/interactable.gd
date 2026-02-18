class_name Interactable extends Node3D


@export var interactable_res: InteractableRes
var collision_shape: CollisionShape3D


func _ready() -> void:
	collision_shape = find_child("CollisionShape3D")
	collision_shape.shape.radius = interactable_res.collider_radius


func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if interactable_res.is_on_enter:
		print("Enter")


func _on_area_3d_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if interactable_res.is_on_enter:
		print("Exit")


func interact():
	print("Pressed F")
