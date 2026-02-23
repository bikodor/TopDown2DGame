extends Node

@export var end_screen_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager
@export var arena_time_ui: ArenaTimeUI
@onready var player = %Player

var pause_menu_scene = preload("res://scene/UI/pause_menu.tscn")

func _ready() -> void:
	MusicPlayer.play()
	player.health_component.died.connect(on_died)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())


func on_died():
	var end_screen_instance = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	if arena_time_manager.is_record():
		MetaProgression.update_time(arena_time_manager.get_time_elapsed())
		end_screen_instance.update_time_to_record(arena_time_ui.format_timer(arena_time_manager.get_time_elapsed()))
	else:
		end_screen_instance.update_time_to_record(arena_time_ui.format_timer(MetaProgression.save_data["meta_record_time"]))
	end_screen_instance.update_gold_to_add(arena_time_manager.gold_to_add())
	end_screen_instance.play_jingle(false)
