@tool

extends Node2D

class_name SoubaCoupe

signal captured_player()
signal ray_captured_player()

@export var player: ProjectileCharacter

@export_range(0, PI / 2) var cone_angle: float:
  set(value):
    cone_angle = value
    update_cone_polygon()
  get:
    return cone_angle

@export_range(1, 1.05) var min_ray_gravity_factor: float = 1.0001
@export_range(1, 1.05) var max_ray_gravity_factor: float = 1.02

@export var cone_height: float:
  set(value):
    cone_height = value
    update_cone_polygon()
  get:
    return cone_height

@onready var area: Area2D = $Area2D
@onready var ray_area: Area2D = $RayArea2D

@onready var cone_polygon: Polygon2D = $ConePolygon2D

var has_captured_player_in_ray: bool = false

@export var left_corner_marker: Node2D
@export var right_corner_marker: Node2D

func update_cone_polygon() -> void:
    if !left_corner_marker || !right_corner_marker || !cone_polygon:
      return

    var left_cone_corner = left_corner_marker.position
    var right_cone_corner = right_corner_marker.position

    cone_polygon.polygon[0] = left_cone_corner
    cone_polygon.polygon[1] = right_cone_corner
    cone_polygon.polygon[2].y = right_cone_corner.y + cone_height
    cone_polygon.polygon[2].x = right_cone_corner.x + cone_height * tan(cone_angle)
    cone_polygon.polygon[3].y = left_cone_corner.y + cone_height
    cone_polygon.polygon[3].x = left_cone_corner.x - cone_height * tan(cone_angle)


func _ready() -> void:
    update_cone_polygon()

    if Engine.is_editor_hint():
        return

    area.body_entered.connect(on_body_entered)
    ray_area.body_entered.connect(on_ray_area_body_entered)

func on_body_entered(body: Node2D) -> void:
    if (body != player):
        return

    captured_player.emit()

func on_ray_area_body_entered(body: Node2D) -> void:
    if (body != player):
        return

    has_captured_player_in_ray = true
    player.set_collision_mask_value(1, false)
    var tween = create_tween()
    tween.tween_property(player, "scale", Vector2(0.8, 0.8), 0.2)
    ray_captured_player.emit()

func get_angle_from_cone(point: Vector2) -> float:
    if point.x < left_corner_marker.global_position.x:
        var player_to_left_cone_corner = left_corner_marker.global_position - point
        return atan(abs(player_to_left_cone_corner.x) / abs(player_to_left_cone_corner.y))

    if point.x > right_corner_marker.global_position.x:
        var player_to_right_cone_corner = right_corner_marker.global_position - point
        return atan(abs(player_to_right_cone_corner.x) / abs(player_to_right_cone_corner.y))

    return 0

func get_vertical_acceleration() -> float:
  var vertical_distance_to_player = global_position.y - player.global_position.y
  if vertical_distance_to_player > 0:
    return 0

  var angle = get_angle_from_cone(player.global_position)

  if angle > cone_angle || (angle > 0 && abs(vertical_distance_to_player) > cone_height):
    return 0

  var gravity = 2 * player.projectile_parameters.jump_height / (player.projectile_parameters.fall_time * player.projectile_parameters.fall_time)
  var factor = (min_ray_gravity_factor - max_ray_gravity_factor) * angle / cone_angle + max_ray_gravity_factor

  return -gravity * factor

func get_lateral_acceleration() -> float:
  if !has_captured_player_in_ray:
    return 0

  var horizontal_distance_to_player = global_position.x - player.global_position.x

  var distance = abs(horizontal_distance_to_player)

  var acceleration_max = 3000

  var normalized_force = clamp((32 * 32) / (distance * distance + 1), 0, 1)

  return sign(horizontal_distance_to_player) * acceleration_max * normalized_force

func _physics_process(_delta: float) -> void:
  if Engine.is_editor_hint():
    return

  player.external_accelerations["gravity_pull"] = Vector2(get_lateral_acceleration(), get_vertical_acceleration())
