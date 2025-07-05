extends Node

class_name Escape

@export var player: ProjectileCharacter

@export var camera: Camera

@export var soubalien: Soubalien
@export var soubalien_path_follow: PathFollow2D
@export var soubalien_path_speed: float = 1.0 / 30.0

@export var transition_mask: TransitionMask

@export var end_portal: Portal
@export var spawn_portal: Portal

@export var countdown_animation_player: AnimationPlayer

@export var cinematic_bars: CinematicBars

@export var hud: Control

var cutscene_camera: Camera2D

var started: bool = false


func _ready() -> void:
    cutscene_camera = camera.switch_to_cutscene_camera()
    cutscene_camera.zoom = Vector2(0.9, 0.9)

    hud.modulate.a = 0

    cinematic_bars.immediate_reveal()

    soubalien.captured_player.connect(on_player_captured)
    soubalien.ray_captured_player.connect(on_ray_captured_player)

    end_portal.spawn()
    end_portal.player_captured.connect(on_player_captured)

    transition_mask.transition_out()
    await spawn_portal.release_player()

    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false

    var position_tween = create_tween()
    var cutscene_camera_position = cutscene_camera.global_position
    position_tween.tween_property(cutscene_camera, "position", Vector2(0, cutscene_camera_position.y), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    position_tween.tween_property(cutscene_camera, "position", cutscene_camera_position, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    await position_tween.finished

    cinematic_bars.unreveal()
    await camera.switch_to_main_camera()

    countdown_animation_player.play("countdown")
    await countdown_animation_player.animation_finished

    started = true

    var tween = create_tween()
    tween.tween_property(hud, "modulate:a", 1.0, 0.5)

    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = true


func end_game() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func play_death_transition() -> void:
    await transition_mask.transition_in()
    end_game()

func on_player_captured() -> void:
    call_deferred("play_death_transition")

func on_ray_captured_player() -> void:
    soubalien_path_speed = 0

    cutscene_camera = camera.switch_to_cutscene_camera()
    var zoom_tween = create_tween()
    zoom_tween.tween_property(cutscene_camera, "zoom", Vector2(2, 2), 1.0)

func _physics_process(delta: float) -> void:
    if not started:
        return

    var direction = sign(player.global_position.x - soubalien.global_position.x)
    soubalien_path_follow.progress_ratio += direction * soubalien_path_speed * delta

    if cutscene_camera != null:
        cutscene_camera.position = lerp(cutscene_camera.position, player.global_position, delta * 3)
