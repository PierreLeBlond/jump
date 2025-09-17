extends ProjectileState

class_name Idle

func enter(previous_state: State, _delta: float) -> void:
    var animation_player = parent.animation_player
    if (previous_state.animation == "run" || previous_state.animation == "walk"):
        animation_player.play("stop")
        animation_player.queue("idle")
    elif (previous_state.animation == "fall"):
        animation_player.play("land")
        animation_player.queue("idle")
    else:
        animation_player.play("idle")

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": parent.projectile_parameters.maximum_velocity,
        "acceleration_factor": 0,
        "deceleration_factor": parent.projectile_parameters.idle_deceleration_factor
    }
