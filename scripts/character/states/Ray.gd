extends ProjectileState

class_name Ray

var tween: Tween

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.velocity = Vector2.ZERO
    parent.set_collision_mask_value(1, false)

    tween = create_tween()
    tween.tween_property(parent, "scale", Vector2(0.8, 0.8), 0.2)

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.air_acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.air_deceleration_factor
    }

func exit() -> void:
    if tween:
        tween.kill()
        tween = null
    parent.set_collision_mask_value(1, true)
    parent.scale = Vector2(1, 1)