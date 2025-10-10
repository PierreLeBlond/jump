extends ProjectileState

class_name Cone

const MAXIMAL_INITIAL_VERTICAL_VELOCITY = 10

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.velocity.y = sign(parent.velocity.y) * min(abs(parent.velocity.y), MAXIMAL_INITIAL_VERTICAL_VELOCITY)

    acceleration_distance = parent.projectile_parameters.air_acceleration_distance
    deceleration_distance = parent.projectile_parameters.air_deceleration_distance

    jump_time = parent.projectile_parameters.fall_time