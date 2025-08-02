extends Control

class_name PulseButton

@export var animation_player: AnimationPlayer
@export var button: Button

func _ready() -> void:
    button.focus_entered.connect(on_button_focus_entered)
    button.focus_exited.connect(on_button_focus_exited)
    button.pressed.connect(on_button_pressed)

func on_button_focus_entered() -> void:
    animation_player.play("pulse")

func on_button_focus_exited() -> void:
    animation_player.play("release")

func on_button_pressed() -> void:
    animation_player.play("press")
