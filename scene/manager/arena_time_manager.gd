extends Node
class_name ArenaTimeManager

signal difficulty_increased(difficulty_level: int)

@export var end_screen_scene: PackedScene
@export var game_length: float = 3600
@onready var timer = $Timer
@onready var difficulty_timer: Timer = $DifficultyTimer

var level = 0
var difficulty_level: int = 0


func _ready() -> void:
	timer.start(game_length)


func gold_to_add():
	return int(floor(get_time_elapsed()/10))


func get_time_elapsed():
	return (game_length - timer.time_left) + (level * game_length)


func is_record():
	var time: float = MetaProgression.save_data["meta_record_time"]
	return ((game_length - timer.time_left) + (level * game_length)) > time


func _on_timer_timeout() -> void:
	timer.start(game_length)
	level += 1
	if level == 24:
		var end_screen_instance = end_screen_scene.instantiate() as EndScreen
		get_parent().add_child(end_screen_instance)
		end_screen_instance.change_to_victory()
		end_screen_instance.play_jingle(true)
	

func _on_difficulty_timer_timeout() -> void:
	difficulty_level += 1
	difficulty_increased.emit(difficulty_level)
