extends CanvasLayer

class_name HUD

@export var animation_player: AnimationPlayer

@export var life_counter: Counter
@export var score_counter: Counter
@export var time_counter: TimeCounter

func _enter_tree() -> void:
    animation_player.play("reveal")
    animation_player.seek(0.0, true)

func unreveal() -> void:
    animation_player.play_backwards("reveal")
