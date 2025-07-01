extends State

class_name Run

@export var gravity_field: State

@export var fall: State

@export var jump: State

@export var walk: State

@export var idle: State

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    maximum_lateral_velocity = parent.projectile_parameters.maximum_velocity * parent.projectile_parameters.run_factor

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field):
        return gravity_field

    if (!parent.is_on_floor()):
        return fall

    if (!parent.movement_controller.wants_to_run()):
        return walk

    if (parent.movement_controller.wants_to_jump() && parent.unlocked_keys.has_unlocked_jump()):
        return jump

    if (!parent.movement_controller.wants_to_move()):
        return idle

    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }
