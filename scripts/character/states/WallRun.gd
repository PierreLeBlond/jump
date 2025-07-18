extends State

class_name WallRun

@export var fall: State

@export var gravity_field: State

@export var double_jump: State

@export var wall_jump: State

@export var canceled_jump: State

var jump_pressed_time: float = 0

var wall_friction_factor: float = 1.0

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    wall_friction_factor = parent.projectile_parameters.wall_friction_factor
    jump_pressed_time = 0

func update(delta: float) -> void:
    jump_pressed_time += delta

    if (!is_on_wall()):
        wall_friction_factor = 1.0

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field):
        return gravity_field

    if (parent.wants_to_jump() && is_on_wall()):
        return wall_jump

    if (parent.wants_to_jump() && parent.projectile_parameters.max_double_jumps > 0):
        return double_jump

    if (parent.velocity.y > 0):
        return fall

    if (parent.cancel_jump() && jump_pressed_time > parent.projectile_parameters.minimum_jump_pressed_time):
        return canceled_jump
    
    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height * wall_friction_factor,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }
