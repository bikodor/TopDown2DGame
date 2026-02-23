extends Camera2D


@onready var player: CharacterBody2D = %Player as Node2D


func _process(delta: float) -> void:
	if player == null:
		return
	global_position = player.global_position
