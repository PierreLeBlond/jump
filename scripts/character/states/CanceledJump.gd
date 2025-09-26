extends ProjectileState

class_name CanceledJump

var canceled_jump_time: float

var buffered_jump_remaining_frames: int = 0

func enter(previous_state: State, delta: float) -> void:
    assert(previous_state is Jump or previous_state is WallJump or previous_state is WallRun)

    super (previous_state, delta)

    # The cancel jump ratio as no physical meaning, we just want to increase gravity until we reach the peak height, and modifying the time to jump seems intuitive
    canceled_jump_time = parent.projectile_parameters.jump_time * parent.projectile_parameters.cancel_jump_factor

    var run_factor = parent.projectile_parameters.run_factor if !parent.wants_to_walk() else 1.0

    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.maximum_velocity * run_factor) / 2 * (parent.projectile_parameters.jump_time + parent.projectile_parameters.fall_time)

    buffered_jump_remaining_frames = 0

func update(_delta: float) -> void:
    if (buffered_jump_remaining_frames > 0):
        buffered_jump_remaining_frames -= 1

    if (parent.wants_to_jump()):
        buffered_jump_remaining_frames = parent.projectile_parameters.buffered_jump_frames

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": canceled_jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }

func can_buffered_jump() -> bool:
    return buffered_jump_remaining_frames > 0
