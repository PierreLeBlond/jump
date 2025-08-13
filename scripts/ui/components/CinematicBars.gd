extends CanvasLayer

class_name CinematicBars

@export var animation_player: AnimationPlayer

func reveal() -> void:
    animation_player.play("reveal")

func unreveal() -> void:
    animation_player.play_backwards("reveal")
