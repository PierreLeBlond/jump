extends State

class_name Idle

@export var jump: State

@export var fall: State

@export var run: State

@export var walk: State

func get_next_state(_delta: float) -> State:
    if (!parent.is_on_floor()):
        return fall
    
    if (parent.movement_controller.wants_to_jump() && parent.unlocked_keys.has_unlocked_jump()):
        return jump

    if (parent.movement_controller.wants_to_run() && parent.unlocked_keys.has_unlocked_run() && parent.movement_controller.wants_to_move()):
        return run

    if (parent.movement_controller.wants_to_move()):
        return walk

    return null
