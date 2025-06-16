extends MovementController

class_name PlayerController

func get_direction() -> int:
    var direction = 0

    if (Input.is_action_pressed("move_right")):
        direction += 1

    if (Input.is_action_pressed("move_left")):
        direction -= 1

    return direction

func wants_to_jump() -> bool:
    return Input.is_action_just_pressed("jump")

func wants_to_run() -> bool:
    return Input.is_action_pressed("run")

func cancel_jump() -> bool:
    return !Input.is_action_pressed("jump")
