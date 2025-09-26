extends ProjectileState

class_name WallRun

var jump_pressed_frames: int = 0

var wall_friction_factor: float = 1.0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    wall_friction_factor = parent.projectile_parameters.wall_friction_factor
    jump_pressed_frames = 0

func update(_delta: float) -> void:
    if (!parent.wall_detector.is_hugging_wall(parent.direction)):
        wall_friction_factor = 1.0

    jump_pressed_frames += 1

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height * wall_friction_factor,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }

func can_cancel_jump() -> bool:
    return jump_pressed_frames > parent.projectile_parameters.cancel_jump_minimum_frames