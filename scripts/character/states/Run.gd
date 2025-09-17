extends ProjectileState

class_name Run

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    maximum_lateral_velocity = parent.projectile_parameters.maximum_velocity * parent.projectile_parameters.run_factor

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }
