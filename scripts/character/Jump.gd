extends State

class_name Jump

@export var fall: State

@export var double_jump: State

@export var wall_jump: State

var jump_pressed_time: float = 0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var velocity = parent.velocity
    velocity.y = -2 * parent.projectile_parameters.jump_height / parent.projectile_parameters.jump_time

    parent.velocity = velocity

    var run_factor = parent.projectile_parameters.run_factor if parent.movement_controller.wants_to_run() else 1.0

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.maximum_velocity * run_factor) / 2 * (parent.projectile_parameters.jump_time + parent.projectile_parameters.fall_time)

    jump_pressed_time = 0

func get_next_state(_delta: float) -> State:
    if (parent.movement_controller.wants_to_jump() && is_on_wall()):
        return wall_jump

    if (parent.movement_controller.wants_to_jump() && is_on_wall()):
        return wall_jump

    if (parent.movement_controller.wants_to_jump()):
        return double_jump

    if (parent.velocity.y > 0):
        return fall

    if (parent.movement_controller.cancel_jump() && jump_pressed_time > parent.projectile_parameters.minimum_jump_pressed_time && jump_pressed_time < parent.projectile_parameters.maximum_jump_pressed_time):
        # TODO: Use a CancelJumpState with a better transition curve
        return fall
    
    return null

func update(delta: float) -> void:
    jump_pressed_time += delta

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
            parent.projectile_parameters.jump_time
        )
    )
