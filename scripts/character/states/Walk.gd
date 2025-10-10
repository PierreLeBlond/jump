extends ProjectileState

class_name Walk

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    final_velocity = parent.projectile_parameters.final_velocity * parent.projectile_parameters.walk_factor
