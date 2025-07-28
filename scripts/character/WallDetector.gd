extends Node

class_name WallDetector

@export var left_wall_rays: Array[RayCast2D]
@export var right_wall_rays: Array[RayCast2D]

func is_on_left_wall() -> bool:
    for ray in left_wall_rays:
        if ray.is_colliding():
            return true

    return false

func is_on_right_wall() -> bool:
    for ray in right_wall_rays:
        if ray.is_colliding():
            return true

    return false

func is_on_wall() -> bool:
    return is_on_left_wall() or is_on_right_wall()

func is_facing_wall(direction: int) -> bool:
    return is_on_left_wall() if direction == -1 else is_on_right_wall()

func get_wall_sign() -> int:
    return 1 if is_on_left_wall() else -1