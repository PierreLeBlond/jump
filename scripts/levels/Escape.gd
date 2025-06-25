extends Node

class_name Escape

@export var player: ProjectileCharacter

@export var souba_coupe: SoubaCoupe
@export var souba_coupe_path_follow: PathFollow2D
@export var souba_coupe_path_duration: float = 30

var souba_coupe_time: float = 0

func _ready() -> void:
    souba_coupe.captured_player.connect(on_player_captured)

func end_game() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func on_player_captured(_body: ProjectileCharacter) -> void:
    call_deferred("end_game")

func _physics_process(delta: float) -> void:
    souba_coupe_time += delta
    souba_coupe_path_follow.progress_ratio = souba_coupe_time / souba_coupe_path_duration
