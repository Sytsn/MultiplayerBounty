class_name PlayerUI extends Control

@export var player: Player
var speed_label: RichTextLabel
var health_label: RichTextLabel


func _ready() -> void:
	speed_label = %Speed
	health_label = %Health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		if player.is_multiplayer_authority():
			speed_label.text = "Speed: " + str(player.velocity.length())
			health_label.text = str(player.health.curr_health)


func connect_to_player(player_node):
	player = player_node
	if player.is_multiplayer_authority():
		print(player.name)
		#player.set_health.connect(_on_set_health)
		health_label.text = str(player.health_res.max_health)


func _on_damage_pressed() -> void:
	player.health._take_damage(25)
