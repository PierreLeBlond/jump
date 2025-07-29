extends Control

class_name TitleScreen

@export var tutorial_button: Button
@export var level_1_button: Button

@export var fade_in_animation: AnimationPlayer

func _ready() -> void:
    tutorial_button.grab_focus()

    tutorial_button.pressed.connect(func(): launch_scene("res://scenes/levels/Tutorial.tscn"))
    level_1_button.pressed.connect(func(): launch_scene("res://scenes/levels/Level1.tscn"))

func launch_scene(scene_path: String) -> void:
    tutorial_button.disabled = true
    level_1_button.disabled = true
    var tree = get_tree()
    fade_in_animation.play_backwards("reveal")
    await fade_in_animation.animation_finished
    tree.change_scene_to_file(scene_path)