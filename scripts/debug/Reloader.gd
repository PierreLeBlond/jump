extends Node

class_name Reloader

func _input(event: InputEvent) -> void:
    if (event.is_action_pressed("reload")):
        get_tree().reload_current_scene()

    if (event.is_action_pressed("menu")):
        get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")