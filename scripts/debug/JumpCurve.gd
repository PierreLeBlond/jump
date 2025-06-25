extends Node2D

class_name JumpCurve

@export var origin_node: CharacterBody2D
@export var projectile_parameters: ProjectileParameters

var direction: int = 1
var center_from_floor: Vector2

func get_curve_point(t: float, maximum_velocity: float, a: float, b: float, center: Vector2) -> Vector2:
    var x = maximum_velocity * t
    var y = a * t * t + b * t
    return center + Vector2(x, y)

func draw_curve(
    center: Vector2,
    start_time: float,
    end_time: float,
    a: float,
    b: float,
    maximum_velocity: float,
    color: Color
) -> void:
    var nb_points = 8
    var points_arc = PackedVector2Array()

    for i in range(nb_points):
        var t = start_time + (end_time - start_time) * i / (nb_points - 1)
        points_arc.append(get_curve_point(t, maximum_velocity, a, b, center))

    for i in range(nb_points - 1):
        draw_line(points_arc[i], points_arc[i + 1], color, 2, true)

func _draw() -> void:
    if (origin_node.velocity.x > 0):
        direction = 1

    if (origin_node.velocity.x < 0):
        direction = -1

    if (origin_node.is_on_floor()):
        center_from_floor = origin_node.transform.origin

    var color = Color(1, 0, 0)

    var gravity = 2 * projectile_parameters.jump_height / (projectile_parameters.jump_time * projectile_parameters.jump_time)
    var maximum_velocity = direction * projectile_parameters.maximum_velocity

    draw_curve(
        center_from_floor,
        0,
        projectile_parameters.jump_time,
        gravity / 2,
        -2 * projectile_parameters.jump_height / projectile_parameters.jump_time,
        maximum_velocity,
        color
    )

    var fall_center = get_curve_point(
        projectile_parameters.jump_time,
        maximum_velocity,
        gravity / 2,
        -2 * projectile_parameters.jump_height / projectile_parameters.jump_time,
        center_from_floor
    )
    var fall_color = Color(0, 0, 1)
    var fall_gravity = 2 * projectile_parameters.jump_height / (projectile_parameters.fall_time * projectile_parameters.fall_time)

    draw_curve(
        fall_center,
        0,
        projectile_parameters.fall_time,
        fall_gravity / 2,
        0,
        maximum_velocity,
        fall_color
    )

    var double_jump_color = Color(1, 0, 0)
    var double_jump_gravity = 2 * projectile_parameters.double_jump_height / (projectile_parameters.double_jump_time * projectile_parameters.double_jump_time)
    var double_jump_maximum_velocity = direction * projectile_parameters.double_jump_maximum_velocity

    draw_curve(
        fall_center,
        0,
        projectile_parameters.double_jump_time,
        double_jump_gravity / 2,
        -2 * projectile_parameters.double_jump_height / projectile_parameters.double_jump_time,
        double_jump_maximum_velocity,
        double_jump_color
        );

    var double_fall_center = get_curve_point(
        projectile_parameters.double_jump_time,
        double_jump_maximum_velocity,
        double_jump_gravity / 2,
        -2 * projectile_parameters.double_jump_height / projectile_parameters.double_jump_time,
        fall_center
        );
    var double_fall_color = Color(0, 0, 1)

    draw_curve(
        double_fall_center,
        0,
        projectile_parameters.fall_time,
        fall_gravity / 2,
        0,
        maximum_velocity,
        double_fall_color
    )

func _process(_delta: float) -> void:
    queue_redraw()
