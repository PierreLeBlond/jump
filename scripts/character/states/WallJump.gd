extends State

class_name WallJump

@export var fall: State

@export var gravity_field: State

@export var double_jump: State

@export var next_wall_jump: State

var jump_pressed_time: float = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var velocity = parent.velocity
    velocity.y = -2 * parent.projectile_parameters.jump_height / parent.projectile_parameters.jump_time
    velocity.x = parent.projectile_parameters.maximum_velocity * previous_state.wall_sign * parent.projectile_parameters.run_factor

    parent.velocity = velocity

    var run_factor = parent.projectile_parameters.run_factor if parent.movement_controller.wants_to_run() else 1.0

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.maximum_velocity * run_factor) / 2 * (parent.projectile_parameters.jump_time + parent.projectile_parameters.fall_time)

    jump_pressed_time = 0

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field):
        return gravity_field

    if (parent.movement_controller.wants_to_jump() && is_on_wall()):
        return next_wall_jump

    if (parent.movement_controller.wants_to_jump()):
        return double_jump

    if (parent.velocity.y > 0):
        return fall

    if (parent.movement_controller.cancel_jump() && jump_pressed_time > parent.projectile_parameters.minimum_jump_pressed_time && jump_pressed_time < parent.projectile_parameters.maximum_jump_pressed_time):
        # TODO: Use a CancelJumpState with a better transition curve
        return fall

    return null

func is_allowed() -> bool:
    return parent.unlocked_keys.has_unlocked_jump()

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
