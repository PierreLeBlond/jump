extends Control

class_name TitleScreen

@export var tutorial_button: Button
@export var escape_level_button: Button

func _ready() -> void:
    tutorial_button.pressed.connect(on_tutorial_button_pressed)
    escape_level_button.pressed.connect(on_escape_level_button_pressed)

func on_tutorial_button_pressed() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/levels/Tutorial.tscn")

func on_escape_level_button_pressed() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/levels/Escape.tscn")
