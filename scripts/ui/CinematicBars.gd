extends CanvasLayer

class_name CinematicBars

@export var animation_player: AnimationPlayer

func immediate_reveal() -> void:
    animation_player.play("reveal")
    animation_player.seek(1.0)

func reveal() -> void:
    animation_player.play("reveal")

func immediate_unreveal() -> void:
    animation_player.play("hide")
    animation_player.seek(1.0)

func unreveal() -> void:
    animation_player.play("unreveal")