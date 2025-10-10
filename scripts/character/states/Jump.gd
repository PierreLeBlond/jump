extends ProjectileState

class_name Jump

var buffered_jump_remaining_frames: int = 0

var jump_pressed_frames: int = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var velocity = parent.velocity
    velocity.y = -2 * parent.projectile_parameters.jump_height / parent.projectile_parameters.jump_time

    parent.velocity = velocity

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    final_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.final_velocity) / 2

    acceleration_distance = parent.projectile_parameters.air_acceleration_distance
    deceleration_distance = parent.projectile_parameters.air_deceleration_distance

    buffered_jump_remaining_frames = 0
    jump_pressed_frames = 0

func update(_delta: float) -> void:
    if (buffered_jump_remaining_frames > 0):
        buffered_jump_remaining_frames -= 1

    if (parent.wants_to_jump()):
        buffered_jump_remaining_frames = parent.projectile_parameters.buffered_jump_frames

    jump_pressed_frames += 1
 
func can_buffered_jump() -> bool:
    return buffered_jump_remaining_frames > 0

func can_double_jump() -> bool:
    return parent.projectile_parameters.max_double_jumps > 0

func can_cancel_jump() -> bool:
    return jump_pressed_frames > parent.projectile_parameters.cancel_jump_minimum_frames