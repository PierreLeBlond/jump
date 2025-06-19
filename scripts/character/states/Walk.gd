extends State

class_name Walk

@export var fall: State

@export var run: State

@export var jump: State

@export var idle: State

func get_next_state(_delta: float) -> State:
    if (!parent.is_on_floor()):
        return fall

    if (parent.movement_controller.wants_to_run() && parent.unlocked_keys.has_unlocked_run()):
        return run

    if (parent.movement_controller.wants_to_jump() && parent.unlocked_keys.has_unlocked_jump()):
        return jump

    if (parent.movement_controller.get_direction() == 0 && parent.velocity.x == 0):
        return idle

    return null

func get_velocity(delta: float) -> Vector2:
    maximum_lateral_velocity = parent.projectile_parameters.maximum_velocity

    return Vector2(
        get_lateral_velocity(
            delta,
            parent.velocity.x,
            maximum_lateral_velocity,
            parent.projectile_parameters.acceleration_time,
            parent.projectile_parameters.deceleration_time
        ),
        0
    )
