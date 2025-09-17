@tool

extends Node2D

class_name Soubalien

@export_range(0, PI / 2) var cone_angle: float:
    set(value):
        cone_angle = value
        update_cone_polygon()
    get:
        return cone_angle

@export var cone_height: float:
    set(value):
        cone_height = value
        update_cone_polygon()
    get:
        return cone_height

@export var area: Area2D
@export var ray_area: Area2D

@export var cone_polygon: Polygon2D

@export var left_corner_marker: Node2D
@export var right_corner_marker: Node2D

func update_cone_polygon() -> void:
    if !left_corner_marker || !right_corner_marker || !cone_polygon:
        return

    var left_cone_corner = left_corner_marker.position
    var right_cone_corner = right_corner_marker.position

    cone_polygon.polygon[9].y = right_cone_corner.y + cone_height
    cone_polygon.polygon[9].x = right_cone_corner.x + cone_height * tan(cone_angle)
    cone_polygon.polygon[10].y = left_cone_corner.y + cone_height
    cone_polygon.polygon[10].x = left_cone_corner.x - cone_height * tan(cone_angle)


func _ready() -> void:
    update_cone_polygon()

func get_angle_from_cone(source_position: Vector2) -> float:
    if source_position.x < left_corner_marker.global_position.x:
        var position_to_left_cone_corner = left_corner_marker.global_position - source_position
        return atan(abs(position_to_left_cone_corner.x) / abs(position_to_left_cone_corner.y))

    if source_position.x > right_corner_marker.global_position.x:
        var position_to_right_cone_corner = right_corner_marker.global_position - source_position
        return atan(abs(position_to_right_cone_corner.x) / abs(position_to_right_cone_corner.y))

    return 0
