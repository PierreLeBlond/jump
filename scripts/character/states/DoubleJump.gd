extends State

class_name DoubleJump

@export var fall: State
@export var wall_jump: State

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var velocity = parent.velocity
    velocity.y = -2 * parent.projectile_parameters.double_jump_height / parent.projectile_parameters.double_jump_time

    parent.velocity = velocity

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.double_jump_maximum_velocity) / 2 * (parent.projectile_parameters.double_jump_time + parent.projectile_parameters.fall_time)

func get_next_state(_delta: float) -> State:
    if (parent.movement_controller.wants_to_jump() && is_on_wall()):
        return wall_jump

    if (parent.velocity.y > 0):
        return fall

    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.double_jump_height,
        "jump_time": parent.projectile_parameters.double_jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }
