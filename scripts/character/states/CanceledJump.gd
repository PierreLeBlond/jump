extends ProjectileState

class_name CanceledJump

var canceled_jump_time: float

var buffered_jump_remaining_frames: int = 0

func enter(previous_state: State, delta: float) -> void:
    assert(previous_state is Jump or previous_state is WallJump or previous_state is WallRun)

    super (previous_state, delta)

    # The cancel jump ratio as no physical meaning, we just want to increase gravity until we reach the peak height, and modifying the time to jump seems intuitive
    canceled_jump_time = parent.projectile_parameters.jump_time * parent.projectile_parameters.cancel_jump_factor

    jump_time = canceled_jump_time
    jump_height = parent.projectile_parameters.jump_height

    buffered_jump_remaining_frames = 0

func update(_delta: float) -> void:
    if (buffered_jump_remaining_frames > 0):
        buffered_jump_remaining_frames -= 1

    if (parent.wants_to_jump()):
        buffered_jump_remaining_frames = parent.projectile_parameters.buffered_jump_frames

func can_buffered_jump() -> bool:
    return buffered_jump_remaining_frames > 0
