@tool

extends Node2D

class_name Soubalien

const RAY_SPRING_CONSTANT = 100
const CONE_SPRING_CONSTANT = 10

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
@export_range(1, 1.05) var max_ray_gravity_factor: float = 1.03

@export var cone_height: float:
    set(value):
        cone_height = value
        update_cone_polygon()
    get:
        return cone_height

@export var area: Area2D
@export var ray_area: Area2D

@export var cone_polygon: Polygon2D

enum SoubalienState {
    IDLE,
    CHASING_PLAYER,
    CAPTURING_PLAYER,
    CAPTURING_PLAYER_IN_RAY,
}

var state: SoubalienState = SoubalienState.IDLE

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

    if Engine.is_editor_hint():
        return

    area.body_entered.connect(on_body_entered)
    ray_area.body_entered.connect(on_ray_area_body_entered)

func start_chasing_player() -> void:
    state = SoubalienState.CHASING_PLAYER

func on_body_entered(body: Node2D) -> void:
    if (body != player):
        return

    if (state != SoubalienState.CAPTURING_PLAYER_IN_RAY):
        return

    state = SoubalienState.CAPTURING_PLAYER

    captured_player.emit()


func on_ray_area_body_entered(body: Node2D) -> void:
    if (body != player):
        return

    if (state != SoubalienState.CHASING_PLAYER):
        return

    state = SoubalienState.CAPTURING_PLAYER_IN_RAY

    ray_captured_player.emit()


func get_angle_from_cone(point: Vector2) -> float:
    if point.x < left_corner_marker.global_position.x:
        var player_to_left_cone_corner = left_corner_marker.global_position - point
        return atan(abs(player_to_left_cone_corner.x) / abs(player_to_left_cone_corner.y))

    if point.x > right_corner_marker.global_position.x:
        var player_to_right_cone_corner = right_corner_marker.global_position - point
        return atan(abs(player_to_right_cone_corner.x) / abs(player_to_right_cone_corner.y))

    return 0


func reset() -> void:
    state = SoubalienState.IDLE

func get_vertical_acceleration() -> float:
    if state == SoubalienState.CAPTURING_PLAYER:
        return 0

    var gravity = 2 * player.projectile_parameters.jump_height / (player.projectile_parameters.fall_time * player.projectile_parameters.fall_time)
    var factor = (min_ray_gravity_factor - max_ray_gravity_factor) * get_angle_from_cone(player.global_position) / cone_angle + max_ray_gravity_factor

    return -gravity * factor

func get_lateral_acceleration() -> float:
    if state == SoubalienState.IDLE:
        return 0

    var spring_contrant = RAY_SPRING_CONSTANT if state == SoubalienState.CAPTURING_PLAYER_IN_RAY else CONE_SPRING_CONSTANT

    var horizontal_distance_to_player = player.global_position.x - global_position.x

    var spring_force = - horizontal_distance_to_player * spring_contrant

    return spring_force

func _physics_process(delta: float) -> void:
    if Engine.is_editor_hint():
        return

    if !has_player_in_cone():
        player.external_accelerations["soubalien_pull"] = Vector2(0, 0)
        return

    if state == SoubalienState.CAPTURING_PLAYER:
        player.global_position = lerp(player.global_position, area.global_position, delta * 20)
        player.velocity = Vector2.ZERO
        player.external_accelerations["soubalien_pull"] = Vector2(0, 0)
        return

    player.external_accelerations["soubalien_pull"] = Vector2(get_lateral_acceleration(), get_vertical_acceleration())


func has_player_in_cone() -> bool:
    if state == SoubalienState.IDLE:
        return false

    var vertical_distance_to_player = global_position.y - player.global_position.y
    if vertical_distance_to_player > 0:
        return false

    var angle = get_angle_from_cone(player.global_position)

    if angle > cone_angle || (angle > 0 && abs(vertical_distance_to_player) > cone_height):
        return false

    return true

func has_player_in_ray() -> bool:
    return state == SoubalienState.CAPTURING_PLAYER_IN_RAY

func has_player_captured() -> bool:
    return state == SoubalienState.CAPTURING_PLAYER
