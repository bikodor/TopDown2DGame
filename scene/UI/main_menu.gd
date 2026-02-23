extends CanvasLayer

var options_menu_scene = preload("res://scene/UI/options_menu.tscn")

func _ready() -> void:
	MusicPlayer.play()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level/level.tscn")


func _on_options_button_pressed() -> void:
	var options_instance = options_menu_scene.instantiate()
	add_child(options_instance)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_upgrades_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/UI/meta_menu.tscn")
