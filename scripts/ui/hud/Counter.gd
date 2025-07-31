extends Control

class_name Counter

@export var animation_player: AnimationPlayer
@export var counter_label: Label

func update_counter(value: int) -> void:
    animation_player.play("pulse")

    if value < 10:
        counter_label.text = "0" + str(value)
    else:
        counter_label.text = str(value)