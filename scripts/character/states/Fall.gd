extends ProjectileState

class_name Fall

var buffered_jump_remaining_frames: int = 0

var coyote_jump_remaining_frames: int = 0

var double_jump_count: int = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    if (previous_state is Run):
        coyote_jump_remaining_frames = parent.projectile_parameters.coyote_jump_frames
    else:
        coyote_jump_remaining_frames = 0

    if (previous_state is DoubleJump):
        double_jump_count -= 1
    else:
        double_jump_count = parent.projectile_parameters.max_double_jumps

    buffered_jump_remaining_frames = 0

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    final_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.final_velocity) / 2

    acceleration_distance = parent.projectile_parameters.air_acceleration_distance
    deceleration_distance = parent.projectile_parameters.air_deceleration_distance

    jump_time = parent.projectile_parameters.fall_time

func update(delta: float) -> void:
    super (delta)

    if (coyote_jump_remaining_frames > 0):
        coyote_jump_remaining_frames -= 1

    if (buffered_jump_remaining_frames > 0):
        buffered_jump_remaining_frames -= 1

    if (parent.wants_to_jump()):
        buffered_jump_remaining_frames = parent.projectile_parameters.buffered_jump_frames

func can_coyote_jump() -> bool:
    return coyote_jump_remaining_frames > 0

func can_double_jump() -> bool:
    return double_jump_count > 0

func can_buffered_jump() -> bool:
    return buffered_jump_remaining_frames > 0
