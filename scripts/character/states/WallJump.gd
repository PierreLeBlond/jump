extends ProjectileState

class_name WallJump

var jump_pressed_time: float = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var velocity = parent.velocity
    velocity.y = -2 * parent.projectile_parameters.jump_height / parent.projectile_parameters.jump_time
    velocity.x = parent.projectile_parameters.maximum_velocity * parent.wall_detector.get_wall_sign() * parent.projectile_parameters.run_factor

    parent.velocity = velocity

    var run_factor = parent.projectile_parameters.run_factor if !parent.wants_to_walk() else 1.0

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.maximum_velocity * run_factor) / 2 * (parent.projectile_parameters.jump_time + parent.projectile_parameters.fall_time)

    jump_pressed_time = 0

func update(delta: float) -> void:
    jump_pressed_time += delta

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.wall_jump_acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.wall_jump_deceleration_factor
    }

func can_cancel_jump() -> bool:
    return jump_pressed_time > parent.projectile_parameters.minimum_jump_pressed_time
