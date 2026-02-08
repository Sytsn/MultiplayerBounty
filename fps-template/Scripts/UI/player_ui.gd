extends Control

@export var player: Player
var speed_label: RichTextLabel


func _ready() -> void:
	speed_label = %Speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed_label.text = "Speed: " + str(player.velocity.length())
