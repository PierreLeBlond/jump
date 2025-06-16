extends Node

class_name MovementController

func get_direction() -> int:
    return 0

func wants_to_jump() -> bool:
    return false

func wants_to_run() -> bool:
    return false

func cancel_jump() -> bool:
    return false
