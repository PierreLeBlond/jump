extends Node

class_name Escape

@export var player: ProjectileCharacter

@export var camera: Camera2D

@export var soubalien: Soubalien
@export var soubalien_path_follow: PathFollow2D
@export var soubalien_path_speed: float = 1.0 / 30.0

@export var transition_mask: TransitionMask


func _ready() -> void:
    soubalien.captured_player.connect(on_player_captured)
    soubalien.ray_captured_player.connect(on_ray_captured_player)
    transition_mask.transition_out(player)

func end_game() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func play_death_transition() -> void:
    player.process_mode = Node.PROCESS_MODE_DISABLED

    var tween = create_tween()
    tween.tween_property(player, "scale", Vector2(0, 0), 1.0)

    await transition_mask.transition_in(player)
    end_game()

func on_player_captured() -> void:
    call_deferred("play_death_transition")

func on_ray_captured_player() -> void:
    soubalien_path_speed = 0
    camera.position_smoothing_speed = 10
    camera.drag_left_margin = 0
    camera.drag_right_margin = 0
    camera.drag_top_margin = 0
    camera.drag_bottom_margin = 0

    var zoom_tween = create_tween()
    zoom_tween.tween_property(camera, "zoom", Vector2(2, 2), 1.0)

func _physics_process(delta: float) -> void:
    var direction = sign(player.global_position.x - soubalien.global_position.x)
    soubalien_path_follow.progress_ratio += direction * soubalien_path_speed * delta
