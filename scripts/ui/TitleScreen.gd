extends Control

class_name TitleScreen

@export var start_button: Button

func _ready() -> void:
    start_button.pressed.connect(on_start_button_pressed)

func on_start_button_pressed() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/levels/Run.tscn")