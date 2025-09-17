extends ProjectileCharacter

@export var cancel_jump_state: ProjectileState
@export var capture_state: ProjectileState
@export var cliff_hang_state: ProjectileState
@export var double_jump_state: ProjectileState
@export var fall_state: Fall
@export var gravity_field_state: ProjectileState
@export var idle_state: ProjectileState
@export var jump_state: Jump
@export var ray_state: ProjectileState
@export var run_state: ProjectileState
@export var walk_state: ProjectileState
@export var wall_jump_state: WallJump
@export var wall_run_state: WallRun

func _ready() -> void:
    super._ready()

    cancel_jump_state.init(self)
    state_machine.add_state(cancel_jump_state)

    state_machine.add_transition(cancel_jump_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(cancel_jump_state, wall_jump_state, wants_to_wall_jump)
    state_machine.add_transition(cancel_jump_state, double_jump_state, wants_to_double_jump)
    # Just profit of the downward force, but go back to fall state immediatly
    state_machine.add_transition(cancel_jump_state, fall_state, func(): return true)

    capture_state.init(self)
    state_machine.add_state(capture_state)

    state_machine.add_transition(capture_state, fall_state, func(): return !is_captured())
    cliff_hang_state.init(self)
    state_machine.add_state(cliff_hang_state)
    state_machine.add_transition(cliff_hang_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(cliff_hang_state, jump_state, wants_to_jump)
    state_machine.add_transition(cliff_hang_state, walk_state, func(): return wants_to_walk() && wants_to_move())
    state_machine.add_transition(cliff_hang_state, run_state, func(): return wants_to_move())
    state_machine.add_transition(cliff_hang_state, fall_state, func(): return !is_on_floor())
    state_machine.add_transition(cliff_hang_state, idle_state, func(): return !cliff_detector.is_on_cliff())

    double_jump_state.init(self)
    state_machine.add_state(double_jump_state)

    state_machine.add_transition(double_jump_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(double_jump_state, wall_jump_state, wants_to_wall_jump)
    state_machine.add_transition(double_jump_state, fall_state, is_falling)

    fall_state.init(self)
    state_machine.add_state(fall_state)

    state_machine.add_transition(fall_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(fall_state, wall_jump_state, wants_to_wall_jump)
    state_machine.add_transition(fall_state, jump_state, func(): return (wants_to_jump() && fall_state.can_coyote_jump()) || (is_on_floor() && fall_state.can_buffered_jump()))
    state_machine.add_transition(fall_state, double_jump_state, func(): return wants_to_jump() && fall_state.can_double_jump())
    state_machine.add_transition(fall_state, walk_state, func(): return is_on_floor() && wants_to_walk() && wants_to_move())
    state_machine.add_transition(fall_state, run_state, func(): return is_on_floor() && wants_to_move())
    state_machine.add_transition(fall_state, idle_state, is_on_floor)

    gravity_field_state.init(self)
    state_machine.add_state(gravity_field_state)

    state_machine.add_transition(gravity_field_state, ray_state, is_in_ray)
    state_machine.add_transition(gravity_field_state, ray_state, func(): return !is_in_gravity_field())

    idle_state.init(self)
    state_machine.add_state(idle_state)

    state_machine.add_transition(idle_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(idle_state, jump_state, wants_to_jump)
    state_machine.add_transition(idle_state, walk_state, func(): return wants_to_walk() && wants_to_move())
    state_machine.add_transition(idle_state, run_state, func(): return wants_to_move())
    state_machine.add_transition(idle_state, fall_state, func(): return !is_on_floor())
    state_machine.add_transition(idle_state, cliff_hang_state, func(): return cliff_detector.is_on_cliff())

    jump_state.init(self)
    state_machine.add_state(jump_state)

    state_machine.add_transition(jump_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(jump_state, wall_jump_state, func(): return wall_detector.is_close_to_wall(direction) && jump_state.can_buffered_jump())
    state_machine.add_transition(jump_state, wall_run_state, func(): return wall_detector.is_hugging_wall(direction))
    state_machine.add_transition(jump_state, double_jump_state, func(): return wants_to_jump() && jump_state.can_double_jump())
    state_machine.add_transition(jump_state, fall_state, is_falling)
    state_machine.add_transition(jump_state, cancel_jump_state, func(): return cancel_jump() && jump_state.can_cancel_jump())

    ray_state.init(self)
    state_machine.add_state(ray_state)

    state_machine.add_transition(ray_state, capture_state, is_captured)
    state_machine.add_transition(ray_state, fall_state, func(): return !is_in_ray())

    run_state.init(self)
    state_machine.add_state(run_state)

    state_machine.add_transition(run_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(run_state, jump_state, wants_to_jump)
    state_machine.add_transition(run_state, fall_state, func(): return !is_on_floor())
    state_machine.add_transition(run_state, walk_state, func(): return wants_to_walk() && wants_to_move())
    state_machine.add_transition(run_state, idle_state, func(): return !wants_to_move())

    walk_state.init(self)
    state_machine.add_state(walk_state)

    state_machine.add_transition(walk_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(walk_state, jump_state, wants_to_jump)
    state_machine.add_transition(walk_state, fall_state, func(): return !is_on_floor())
    state_machine.add_transition(walk_state, run_state, func(): return !wants_to_walk() && wants_to_move())
    state_machine.add_transition(walk_state, idle_state, func(): return !wants_to_move())

    wall_jump_state.init(self)
    state_machine.add_state(wall_jump_state)

    state_machine.add_transition(wall_jump_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(wall_jump_state, wall_jump_state, func(): return wants_to_jump() && wall_detector.is_close_to_wall(direction))
    state_machine.add_transition(wall_jump_state, fall_state, func(): return is_falling)
    state_machine.add_transition(wall_jump_state, cancel_jump_state, func(): return cancel_jump() && wall_jump_state.can_cancel_jump())

    wall_run_state.init(self)
    state_machine.add_state(wall_run_state)

    state_machine.add_transition(wall_run_state, gravity_field_state, is_in_gravity_field)
    state_machine.add_transition(wall_run_state, wall_jump_state, func(): return wants_to_jump() && wall_detector.is_close_to_wall(direction))
    state_machine.add_transition(wall_run_state, fall_state, func(): return is_falling)
    state_machine.add_transition(wall_run_state, cancel_jump_state, func(): return cancel_jump() && wall_run_state.can_cancel_jump())

func is_in_gravity_field() -> bool:
    return soubalien && soubalien.has_player_in_cone()

func is_in_ray() -> bool:
    return soubalien && soubalien.has_player_in_ray()

func is_captured() -> bool:
    return soubalien && soubalien.has_player_captured()

func wants_to_wall_jump() -> bool:
    return wants_to_jump() && wall_detector.is_close_to_wall(direction)

func wants_to_double_jump() -> bool:
    return wants_to_jump() && projectile_parameters.max_double_jumps > 0

func is_falling() -> bool:
    return velocity.y > 0
