extends State

class_name GravityField

@export var fall: State

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.velocity.y = sign(parent.velocity.y) * min(abs(parent.velocity.y), 10)

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field == false):
        return fall

    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.air_acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.air_deceleration_factor
    }
