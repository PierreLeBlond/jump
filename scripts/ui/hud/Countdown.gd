extends CanvasLayer

class_name Countdown

@export var animation_player: AnimationPlayer

const BASE_BPM: int = 120
@export var bpm: int = BASE_BPM

func play() -> void:
    animation_player.speed_scale = float(bpm) / BASE_BPM
    animation_player.play("countdown")
    await animation_player.animation_finished

func stop() -> void:
    animation_player.stop()