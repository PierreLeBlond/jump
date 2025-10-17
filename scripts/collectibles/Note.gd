extends Area2D

class_name Note

const DEFAULT_BPM: float = 60.0
const note_layer = 4

@export var bpm: float = DEFAULT_BPM
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    animation_player.speed_scale = bpm / DEFAULT_BPM
    animation_player.animation_finished.connect(play_bounce)
    play_bounce("")

func play_bounce(_animation_name: String) -> void:
    animation_player.play("bounce")
    animation_player.advance(0.0)

func offset_animation(offset_ratio: float) -> void:
    var time = offset_ratio * animation_player.get_animation("bounce").length
    animation_player.seek(time)

func capture():
    animation_player.animation_finished.disconnect(play_bounce)
    set_collision_layer_value(note_layer, false)
    animation_player.play("fly")