extends Control

class_name TitleScreen

@export var tutorial_button: Button
@export var level_1_button: Button

func _ready() -> void:
    tutorial_button.pressed.connect(on_tutorial_button_pressed)
    level_1_button.pressed.connect(on_level_1_button_pressed)

func on_tutorial_button_pressed() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/levels/Tutorial.tscn")

func on_level_1_button_pressed() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/levels/Level1.tscn")
