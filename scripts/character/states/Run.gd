extends ProjectileState

class_name Run

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    final_velocity = parent.projectile_parameters.final_velocity

    acceleration_distance = parent.projectile_parameters.acceleration_distance
    deceleration_distance = parent.projectile_parameters.deceleration_distance
