extends Control

var player: Player

func connect_to_player(player_node: Player):
	player = player_node


func _on_button_pressed() -> void:
	$PlayerId.text = player.name
