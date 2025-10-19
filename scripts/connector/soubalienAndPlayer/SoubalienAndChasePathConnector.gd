extends Node

class_name SoubalienAndChasePathConnector

const CHASE_PATH_SPEED_ACCELERATION_THRESHOLD = 1600

@export var soubalien: Soubalien
@export var player: Player
@export var chase_path: Path

func _ready() -> void:
    chase_path.speed = player.projectile_parameters.final_velocity * 0.7

func update_chase_path_speed() -> void:
    if abs(soubalien.global_position.x - player.global_position.x) < CHASE_PATH_SPEED_ACCELERATION_THRESHOLD:
        chase_path.speed = player.projectile_parameters.final_velocity * 0.7
    else:
        chase_path.speed = player.projectile_parameters.final_velocity

func _physics_process(_delta: float) -> void:
    update_chase_path_speed()