extends ProjectileState

class_name Ray

const RAY_ACCELERATION_DISTANCE = 512
const RAY_DECELERATION_DISTANCE = 8

var tween: Tween

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.velocity = Vector2.ZERO
    parent.set_collision_mask_value(1, false)

    tween = create_tween()
    tween.tween_property(parent, "scale", Vector2(0.8, 0.8), 0.3)

    acceleration_distance = RAY_ACCELERATION_DISTANCE
    deceleration_distance = RAY_DECELERATION_DISTANCE

    jump_time = parent.projectile_parameters.fall_time

func exit() -> void:
    if tween:
        tween.kill()
        tween = null
    parent.set_collision_mask_value(1, true)
    parent.scale = Vector2(1, 1)