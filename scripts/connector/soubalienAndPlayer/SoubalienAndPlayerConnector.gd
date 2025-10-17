extends Node2D

class_name SoubalienAndPlayerConnector

const RAY_SPRING_CONSTANT = 500
const CONE_SPRING_CONSTANT = 10

signal captured_player()
signal ray_captured_player()

enum SoubalienState {
    IDLE,
    CHASING_PLAYER,
    CAPTURING_PLAYER,
    CAPTURING_PLAYER_IN_RAY,
}

var soubalien_state: SoubalienState = SoubalienState.IDLE

@export var whirl_and_pinch_area: Area2D

@export var soubalien: Soubalien
@export var player: Player
@export var whirl_and_pinch: WhirlAndPinch

@export var capture_state: Capture
@export var cone_state: Cone
@export var ray_state: Ray

@export_range(1, 2.0) var min_ray_gravity_factor: float = 1.001
@export_range(1, 2.0) var max_ray_gravity_factor: float = 1.1

func _ready() -> void:
    whirl_and_pinch.source = soubalien.area
    whirl_and_pinch.sprite = player.sprite_2d
    whirl_and_pinch.sprite_parent = player

    capture_state.init(player)

    player.state_machine.add_transition(capture_state, player.fall_state, func(): return !has_player_captured())

    ray_state.init(player)

    player.state_machine.add_transition(ray_state, capture_state, has_player_captured)
    player.state_machine.add_transition(ray_state, player.fall_state, func(): return !has_player_in_ray())

    cone_state.init(player)

    player.state_machine.add_transition(cone_state, ray_state, has_player_in_ray)
    player.state_machine.add_transition(cone_state, capture_state, has_player_captured)
    player.state_machine.add_transition(cone_state, player.fall_state, func(): return !has_player_in_cone())

    # TODO: Beware of other states that could be added to the player state machine
    for state in player.state_machine.states:
        player.state_machine.add_transition(state, cone_state, func(): return has_player_in_cone())
        player.state_machine.add_transition(state, ray_state, func(): return has_player_in_ray())

    player.state_machine.add_state(capture_state)
    player.state_machine.add_state(ray_state)
    player.state_machine.add_state(cone_state)

    soubalien.area.body_entered.connect(on_body_entered)
    soubalien.ray_area.body_entered.connect(on_ray_area_body_entered)

    remove_child(whirl_and_pinch_area)
    soubalien.add_child(whirl_and_pinch_area)

    whirl_and_pinch_area.body_entered.connect(on_whirl_and_pinch_area_body_entered)
    whirl_and_pinch_area.body_exited.connect(on_whirl_and_pinch_area_body_exited)

func on_whirl_and_pinch_area_body_entered(body: Node2D) -> void:
    if (body != player):
        return

    whirl_and_pinch.setup()

    whirl_and_pinch.whirl = 0.0
    whirl_and_pinch.pinch = 0.1

func on_whirl_and_pinch_area_body_exited(body: Node2D) -> void:
    if (body != player):
        return

    whirl_and_pinch.cleanup.call_deferred()


func start_chasing_player() -> void:
    soubalien_state = SoubalienState.CHASING_PLAYER

func on_body_entered(body: Node2D) -> void:
    if (body != player):
        return

    if (soubalien_state != SoubalienState.CAPTURING_PLAYER_IN_RAY):
        return

    soubalien_state = SoubalienState.CAPTURING_PLAYER

    captured_player.emit()


func on_ray_area_body_entered(body: Node2D) -> void:
    if (body != player):
        return

    if (soubalien_state != SoubalienState.CHASING_PLAYER):
        return

    soubalien_state = SoubalienState.CAPTURING_PLAYER_IN_RAY

    ray_captured_player.emit()

func reset() -> void:
    soubalien_state = SoubalienState.IDLE

func get_vertical_acceleration() -> float:
    var gravity = 2 * player.projectile_parameters.jump_height / (player.projectile_parameters.fall_time * player.projectile_parameters.fall_time)
    var factor = (min_ray_gravity_factor - max_ray_gravity_factor) * soubalien.get_angle_from_cone(player.global_position) / soubalien.cone_angle + max_ray_gravity_factor

    return -gravity * factor

func get_lateral_acceleration() -> float:
    if soubalien_state == SoubalienState.IDLE:
        return 0

    var spring_contrant = RAY_SPRING_CONSTANT if soubalien_state == SoubalienState.CAPTURING_PLAYER_IN_RAY else CONE_SPRING_CONSTANT

    var horizontal_distance_to_player = player.global_position.x - soubalien.area.global_position.x

    var spring_force = - horizontal_distance_to_player * spring_contrant

    return spring_force

func _physics_process(delta: float) -> void:
    if !has_player_in_cone() && !has_player_in_ray():
        player.external_accelerations["soubalien_pull"] = Vector2(0, 0)
        return

    if soubalien_state == SoubalienState.CAPTURING_PLAYER:
        player.global_position = lerp(player.global_position, soubalien.area.global_position, delta * 20)
        player.velocity = Vector2.ZERO
        player.external_accelerations["soubalien_pull"] = Vector2(0, 0)
        return

    player.external_accelerations["soubalien_pull"] = Vector2(get_lateral_acceleration(), get_vertical_acceleration())


func has_player_in_cone() -> bool:
    if soubalien_state == SoubalienState.IDLE:
        return false

    var vertical_distance_to_player = soubalien.area.global_position.y - player.global_position.y
    if vertical_distance_to_player > 0:
        return false

    var angle = soubalien.get_angle_from_cone(player.global_position)

    if angle > soubalien.cone_angle || (angle > 0 && abs(vertical_distance_to_player) > soubalien.cone_height):
        return false

    return true

func has_player_in_ray() -> bool:
    return soubalien_state == SoubalienState.CAPTURING_PLAYER_IN_RAY

func has_player_captured() -> bool:
    return soubalien_state == SoubalienState.CAPTURING_PLAYER
