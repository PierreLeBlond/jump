extends ProjectileState

class_name WallRun

var jump_pressed_frames: int = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    jump_pressed_frames = 0

    acceleration_distance = parent.projectile_parameters.wall_jump_acceleration_distance
    deceleration_distance = parent.projectile_parameters.wall_jump_deceleration_distance

func update(_delta: float) -> void:
    if (!parent.wall_detector.is_hugging_wall(parent.direction)):
        jump_height = parent.projectile_parameters.jump_height
    else:
        jump_height = parent.projectile_parameters.jump_height * parent.projectile_parameters.wall_friction_factor

    jump_pressed_frames += 1

func can_cancel_jump() -> bool:
    return jump_pressed_frames > parent.projectile_parameters.cancel_jump_minimum_frames