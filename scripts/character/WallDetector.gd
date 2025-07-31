extends Node

class_name WallDetector

@export var left_wall_hugging_rays: Array[RayCast2D]
@export var right_wall_hugging_rays: Array[RayCast2D]
@export var left_wall_close_rays: Array[RayCast2D]
@export var right_wall_close_rays: Array[RayCast2D]

func are_rays_colliding(rays: Array[RayCast2D]) -> bool:
    for ray in rays:
        if ray.is_colliding():
            return true

    return false

func is_hugging_left_wall() -> bool:
    return are_rays_colliding(left_wall_hugging_rays)

func is_hugging_right_wall() -> bool:
    return are_rays_colliding(right_wall_hugging_rays)

func is_hugging_wall(direction: int) -> bool:
    return is_hugging_left_wall() if direction == -1 else is_hugging_right_wall()

func is_close_to_left_wall() -> bool:
    return are_rays_colliding(left_wall_close_rays)

func is_close_to_right_wall() -> bool:
    return are_rays_colliding(right_wall_close_rays)

# If wall if facing back, it will still allow wall jump thanks to longer intersection rays
func is_close_to_wall(direction: int) -> bool:
    return is_hugging_left_wall() or is_close_to_right_wall() if direction == -1 else is_hugging_right_wall() or is_close_to_left_wall()

func get_wall_sign() -> int:
    return 1 if is_close_to_left_wall() else -1