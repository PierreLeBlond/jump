extends Node2D

class_name CircleTransitionDebug

@export var player: ProjectileCharacter

func _ready() -> void:
    player.position = Vector2(0, 0)

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_D:
            Transition.create_circle_transition_in(get_tree().root, player)