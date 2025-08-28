extends State

class_name CanceledJump

const OVERSHOT_FACTOR = 0.4

@export var fall: State

@export var gravity_field: State

@export var double_jump: State

@export var wall_jump: State

var canceled_jump_height: float
var canceled_jump_time: float

func enter(previous_state: State, delta: float) -> void:
    assert(previous_state is Jump or previous_state is WallJump or previous_state is WallRun)

    super (previous_state, delta)

    # Basically, we change physics parameters to reach the top of our curve sooner, with a modified transition curve
    # BUT this is bugged, we keep it like that until it is properly fixed while keeping the same game feel

    var jump_pressed_gravity = 2 * parent.projectile_parameters.jump_height / (parent.projectile_parameters.jump_time * parent.projectile_parameters.jump_time)
    var jump_pressed_time = previous_state.jump_pressed_time
    var jump_pressed_height = jump_pressed_gravity * jump_pressed_time * jump_pressed_time / 2 + -2 * parent.projectile_parameters.jump_height * jump_pressed_time / parent.projectile_parameters.jump_time

    canceled_jump_time = jump_pressed_time + OVERSHOT_FACTOR * parent.projectile_parameters.jump_time
    # So, this is wrong, it just artificially adds a downward force, and it just happen that this is what we kind of want
    # Hovewer, it can cause some bugs, which is why we patch get_next_state
    canceled_jump_height = jump_pressed_height + OVERSHOT_FACTOR * parent.projectile_parameters.jump_height
    # This might be the correct evaluation
    # canceled_jump_height = - jump_pressed_height + OVERSHOT_FACTOR * parent.projectile_parameters.jump_height

    var gravity = 2 * canceled_jump_height / (canceled_jump_time * canceled_jump_time)

    var vertical_velocity = -2 * canceled_jump_height / canceled_jump_time + gravity * jump_pressed_time

    parent.velocity.y = vertical_velocity

    var run_factor = parent.projectile_parameters.run_factor if !parent.wants_to_walk() else 1.0

    # We should only jump to max distance if we are jumping at full speed. At speed 0, we should still be able to move to half the maximum distance.
    maximum_lateral_velocity = (abs(parent.velocity.x) + parent.projectile_parameters.maximum_velocity * run_factor) / 2 * (parent.projectile_parameters.jump_time + parent.projectile_parameters.fall_time)

func get_next_state(_delta: float) -> State:
    if (parent.is_in_gravity_field):
        return gravity_field

    if (parent.wants_to_jump() && parent.wall_detector.is_close_to_wall(parent.direction)):
        return wall_jump

    if (parent.wants_to_jump() && parent.projectile_parameters.max_double_jumps > 0):
        return double_jump

    # if (parent.velocity.y > 0):
        # return fall

    # return null

    # Just profit of the downward force, but go back to fall state immediatly
    return fall

func get_parameters() -> Dictionary:
    return {
        "jump_height": canceled_jump_height,
        "jump_time": canceled_jump_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }
