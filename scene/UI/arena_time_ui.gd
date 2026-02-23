extends CanvasLayer
class_name ArenaTimeUI

@export var arena_time_manager: Node
@onready var label: Label = %Label

func _process(delta: float) -> void:
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_timer(time_elapsed)

func format_timer(seconds: float):
	var minutes = int(floor(seconds / 60))
	var remaining_seconds = int(floor(seconds - (minutes * 60)))
	if seconds < 3600:
		return str(minutes) + " : " + "%02d" % remaining_seconds
	else:
		var hours = int(floor(minutes / 60))
		var remaining_minutes = int(floor(minutes - (hours * 60)))
		return str(hours) + " : " + "%02d" % remaining_minutes + " : " + "%02d" % remaining_seconds
