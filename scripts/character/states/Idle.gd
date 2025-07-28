extends State

class_name Idle

@export var cliff_hang: State

@export var gravity_field: State

@export var jump: State

@export var fall: State

@export var run: State

@export var walk: State

func enter(previous_state: State, _delta: float) -> void:
    var animation_player = parent.animation_player
    if (previous_state.animation == "run" || previous_state.animation == "walk"):
        animation_player.play("stop")
        animation_player.queue("idle")
    elif (previous_state.animation == "fall"):
        animation_player.play("land")
        animation_player.queue("idle")
    else:
        animation_player.play("idle")

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field):
        return gravity_field

    if (!parent.is_on_floor()):
        return fall
    
    if (parent.cliff_detector.is_on_cliff()):
        return cliff_hang

    if (parent.wants_to_jump()):
        return jump

    if (parent.wants_to_walk() && parent.wants_to_move()):
        return walk

    if (parent.wants_to_move()):
        return run

    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": parent.projectile_parameters.maximum_velocity,
        "acceleration_factor": 0,
        "deceleration_factor": parent.projectile_parameters.idle_deceleration_factor
    }
