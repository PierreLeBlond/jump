extends ProjectileState

class_name CliffHang

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    var cliff_sign = parent.cliff_detector.get_cliff_sign()
    var direction = parent.direction * cliff_sign

    var animation_name = "frontcliffhang" if direction == 1 else "backcliffhang"
    parent.animation_player.play(animation_name)

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": parent.projectile_parameters.maximum_velocity,
        "acceleration_factor": 0,
        "deceleration_factor": parent.projectile_parameters.idle_deceleration_factor
    }
