extends Node

class_name CliffDetector

@export var left_inner_ground_ray: RayCast2D
@export var right_inner_ground_ray: RayCast2D
@export var left_outer_ground_ray: RayCast2D
@export var right_outer_ground_ray: RayCast2D

func is_on_cliff() -> bool:
    return !left_inner_ground_ray.is_colliding() || !right_inner_ground_ray.is_colliding()

func get_cliff_sign() -> int:
    return 1 if left_outer_ground_ray.is_colliding() else -1