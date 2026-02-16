extends Node3D

@onready var player_container = $PlayerContainer

func _ready():
	player_container.connect("child_entered_tree", _on_player_spawned)

func _on_player_spawned(player_node: Node):
	if not player_node is Player:
		return

	var local_id = get_multiplayer().get_unique_id()  # or get_tree().get_network_unique_id()
	var player_id = player_node.name.to_int()

	if player_id == local_id:
		%PlayerUI.connect_to_player(player_node)
