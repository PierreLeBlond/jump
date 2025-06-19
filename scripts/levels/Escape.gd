extends Node

class_name Escape

@onready var souba_coupe: SoubaCoupe = $SoubaCoupe
@export var souba_coupe_speed: float = 100

func _ready() -> void:
    souba_coupe.captured_player.connect(on_player_captured)

func end_game() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func on_player_captured(_body: ProjectileCharacter) -> void:
    call_deferred("end_game")

func _physics_process(delta: float) -> void:
    souba_coupe.position += Vector2(souba_coupe_speed * delta, 0)
