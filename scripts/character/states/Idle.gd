extends State

class_name Idle

@export var gravity_field: State

@export var jump: State

@export var fall: State

@export var run: State

@export var walk: State

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field):
        return gravity_field

    if (!parent.is_on_floor()):
        return fall
    
    if (parent.movement_controller.wants_to_jump() && parent.unlocked_keys.has_unlocked_jump()):
        return jump

    if (parent.movement_controller.wants_to_run() && parent.unlocked_keys.has_unlocked_run() && parent.movement_controller.wants_to_move()):
        return run

    if (parent.movement_controller.wants_to_move()):
        return walk

    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": parent.projectile_parameters.maximum_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }
