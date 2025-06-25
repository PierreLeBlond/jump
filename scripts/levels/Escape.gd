extends Node

class_name Escape

@export var player: ProjectileCharacter

@export var camera: Camera2D

@export var souba_coupe: SoubaCoupe
@export var souba_coupe_path_follow: PathFollow2D
@export var souba_coupe_path_speed: float = 1.0 / 30.0


func _ready() -> void:
    souba_coupe.captured_player.connect(on_player_captured)
    souba_coupe.ray_captured_player.connect(on_ray_captured_player)

func end_game() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func on_player_captured() -> void:
    call_deferred("end_game")

func on_ray_captured_player() -> void:
    souba_coupe_path_speed = 0
    camera.position_smoothing_speed = 10
    camera.drag_left_margin = 0
    camera.drag_right_margin = 0
    camera.drag_top_margin = 0
    camera.drag_bottom_margin = 0

    var zoom_tween = create_tween()
    zoom_tween.tween_property(camera, "zoom", Vector2(2, 2), 1.0)

func _physics_process(delta: float) -> void:
    souba_coupe_path_follow.progress_ratio += souba_coupe_path_speed * delta
