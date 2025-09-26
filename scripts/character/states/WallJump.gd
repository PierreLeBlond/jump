extends ProjectileState

class_name WallJump

var buffered_jump_remaining_frames: int = 0

var jump_pressed_frames: int = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var velocity = parent.velocity
    velocity.y = -2 * parent.projectile_parameters.jump_height / parent.projectile_parameters.jump_time
    velocity.x = parent.projectile_parameters.maximum_velocity * parent.wall_detector.get_wall_sign() * parent.projectile_parameters.run_factor

    parent.velocity = velocity

    var run_factor = parent.projectile_parameters.run_factor if !parent.wants_to_walk() else 1.0

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.maximum_velocity * run_factor) / 2 * (parent.projectile_parameters.jump_time + parent.projectile_parameters.fall_time)

    jump_pressed_frames = 0

    buffered_jump_remaining_frames = 0

func update(_delta: float) -> void:
    if (buffered_jump_remaining_frames > 0):
        buffered_jump_remaining_frames -= 1

    if (parent.wants_to_jump()):
        buffered_jump_remaining_frames = parent.projectile_parameters.buffered_jump_frames

    jump_pressed_frames += 1

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.wall_jump_acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.wall_jump_deceleration_factor
    }

func can_buffered_jump() -> bool:
    return buffered_jump_remaining_frames > 0

func can_cancel_jump() -> bool:
    return jump_pressed_frames > parent.projectile_parameters.cancel_jump_minimum_frames
