extends State

class_name Jump

@export var fall: State

@export var gravity_field: State

@export var double_jump: State

@export var wall_run: State

@export var wall_jump: State

@export var canceled_jump: State

var buffered_jump_remaining_frames: int = 0

var jump_pressed_time: float = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var velocity = parent.velocity
    velocity.y = -2 * parent.projectile_parameters.jump_height / parent.projectile_parameters.jump_time

    parent.velocity = velocity

    var run_factor = parent.projectile_parameters.run_factor if !parent.wants_to_walk() else 1.0

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.maximum_velocity * run_factor) / 2 * (parent.projectile_parameters.jump_time + parent.projectile_parameters.fall_time)

    jump_pressed_time = 0

    buffered_jump_remaining_frames = 0

func get_next_state(_delta: float) -> State:
    if (parent.soubalien && parent.soubalien.has_player_in_cone()):
        return gravity_field

    if (parent.wall_detector.is_close_to_wall(parent.direction) && buffered_jump_remaining_frames > 0):
        return wall_jump

    if (parent.wall_detector.is_hugging_wall(parent.direction)):
        return wall_run

    if (parent.wants_to_jump() && parent.projectile_parameters.max_double_jumps > 0):
        return double_jump

    if (parent.velocity.y > 0):
        return fall

    if (parent.cancel_jump() && jump_pressed_time > parent.projectile_parameters.minimum_jump_pressed_time):
        return canceled_jump
    
    return null

func update(delta: float) -> void:
    jump_pressed_time += delta

    if (buffered_jump_remaining_frames > 0):
        buffered_jump_remaining_frames -= 1

    if (parent.wants_to_jump()):
        buffered_jump_remaining_frames = parent.projectile_parameters.buffered_jump_frames

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }
