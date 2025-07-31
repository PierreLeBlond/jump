extends Control

class_name HUD

@export var animation_player: AnimationPlayer

@export var life_counter: Counter
@export var score_counter: Counter
@export var time_counter: TimeCounter

@export var game_run: GameRun

func _ready() -> void:
    game_run.life_changed.connect(life_counter.update_counter)
    game_run.score_changed.connect(score_counter.update_counter)
    game_run.time_changed.connect(time_counter.update_time_counter)

func reveal() -> void:
    animation_player.play("reveal")

func unreveal() -> void:
    animation_player.play_backwards("reveal")

func immediate_reveal() -> void:
    animation_player.play("reveal")
    animation_player.seek(animation_player.get_animation("reveal").get_length())

func immediate_unreveal() -> void:
    animation_player.play_backwards("reveal")
    animation_player.seek(0.0)