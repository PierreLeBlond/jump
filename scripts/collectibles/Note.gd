extends Area2D

class_name Note

const note_layer = 4

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    # Should offset animation based on horizontal position, for a wave effect
    var offset = floori(global_position.x) % 1024
    var time = float(offset) / 1024 * animation_player.get_animation("bounce").length
    animation_player.play("bounce")
    animation_player.seek(time)

func capture():
    set_collision_layer_value(note_layer, false)
    animation_player.play("fly")

func restore():
    set_collision_layer_value(note_layer, true)
    animation_player.play_backwards("fly")
    await animation_player.animation_finished
    animation_player.play_backwards("bounce")
