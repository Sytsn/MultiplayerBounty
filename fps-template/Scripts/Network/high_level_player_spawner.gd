extends MultiplayerSpawner 

@export var network_player: PackedScene
@export var player_colors: Array[Material]

var player_index: int = 0

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)


func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	var player: Node = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)
	player.mesh.set_surface_override_material(0, player_colors[player_index])
	player_index += 1
	if player_index > 3:
		player_index = 0
