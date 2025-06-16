extends State

class_name Fall

@export var run: State

@export var jump: State

@export var double_jump: State

@export var wall_jump: State

@export var idle: State

var buffered_jump_remaining_frames: int = 0

var coyote_jump_remaining_frames: int = 0

var double_jump_count: int = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    if (previous_state == run):
        coyote_jump_remaining_frames = parent.projectile_parameters.coyote_jump_frames
    else:
        coyote_jump_remaining_frames = 0
        maximum_lateral_velocity = previous_state.maximum_lateral_velocity

    if (previous_state == double_jump):
        double_jump_count -= 1
    else:
        double_jump_count = parent.projectile_parameters.max_double_jumps

func get_next_state(_delta: float) -> State:
    if (parent.movement_controller.wants_to_jump() && is_on_wall()):
        return wall_jump

    if (parent.movement_controller.wants_to_jump() && coyote_jump_remaining_frames > 0):
        return jump

    if (parent.movement_controller.wants_to_jump() && double_jump_count > 0):
        return double_jump

    if (parent.is_on_floor() && buffered_jump_remaining_frames > 0):
        return jump

    if (parent.is_on_floor() && parent.movement_controller.get_direction() != 0):
        return run

    if (parent.is_on_floor()):
        return idle

    return null

func update(delta: float) -> void:
    super (delta)

    if (coyote_jump_remaining_frames > 0):
        coyote_jump_remaining_frames -= 1

    if (buffered_jump_remaining_frames > 0):
        buffered_jump_remaining_frames -= 1

    if (parent.movement_controller.wants_to_jump()):
        buffered_jump_remaining_frames = parent.projectile_parameters.buffered_jump_frames

func get_velocity(delta: float) -> Vector2:
    return Vector2(
        get_lateral_velocity(
                delta,
                parent.velocity.x,
                maximum_lateral_velocity,
                parent.projectile_parameters.air_acceleration_time,
                parent.projectile_parameters.air_deceleration_time
            ),
        get_vertical_velocity(
            delta,
            parent.velocity.y,
            parent.projectile_parameters.jump_height,
            parent.projectile_parameters.fall_time
        )
    )
