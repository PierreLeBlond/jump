extends Node

class_name CornerCorrector

var parent: Node2D

@export var outer_left_ceiling_ray_cast: RayCast2D
@export var inner_left_ceiling_ray_cast: RayCast2D
@export var outer_right_ceiling_ray_cast: RayCast2D
@export var inner_right_ceiling_ray_cast: RayCast2D

func init(node: Node2D) -> void:
    self.parent = node

func apply_corner_correction() -> void:
    var outer_left = outer_left_ceiling_ray_cast
    var inner_left = inner_left_ceiling_ray_cast
    var outer_right = outer_right_ceiling_ray_cast
    var inner_right = inner_right_ceiling_ray_cast

    # Using ceil and floor to avoid subpixel positions can result in off by one pixel when moving away the projectile from the corner.

    if (outer_left.is_colliding() && !inner_left.is_colliding()):
        var x = floori(outer_left.get_collision_point().x)
        var offset = 16 - (x % 16)
        parent.position = Vector2(parent.position.x + offset, parent.position.y)

    if (outer_right.is_colliding() && !inner_right.is_colliding()):
        var x = ceili(outer_right.get_collision_point().x)
        var offset = x % 16
        parent.position = Vector2(parent.position.x - offset, parent.position.y)
