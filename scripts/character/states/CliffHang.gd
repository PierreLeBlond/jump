extends State

class_name CliffHang

@export var idle: State

@export var gravity_field: State

@export var jump: State

@export var fall: State

@export var run: State

@export var walk: State

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    var cliff_sign = parent.cliff_detector.get_cliff_sign()
    var direction = parent.direction * cliff_sign

    var animation_name = "frontcliffhang" if direction == 1 else "backcliffhang"
    parent.animation_player.play(animation_name)

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field):
        return gravity_field

    if (parent.wants_to_jump()):
        return jump

    if (parent.wants_to_walk() && parent.wants_to_move()):
        return walk

    if (parent.wants_to_move()):
        return run

    if (!parent.is_on_floor()):
        return fall
    
    if (!parent.cliff_detector.is_on_cliff()):
        return idle

    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": parent.projectile_parameters.maximum_velocity,
        "acceleration_factor": 0,
        "deceleration_factor": parent.projectile_parameters.idle_deceleration_factor
    }
