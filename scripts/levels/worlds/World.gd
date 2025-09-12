extends Node

class_name World

signal has_died()
signal has_finished()

@export var player: ProjectileCharacter
@export var player_camera: Camera

@export var camera_manager: CameraManager

@export var game_run: GameRun

@export var hud: HUD

var notes: Array[Note] = []

func _ready() -> void:
    game_run.life_changed.connect(hud.life_counter.update_counter)
    game_run.score_changed.connect(hud.score_counter.update_counter)
    game_run.time_changed.connect(hud.time_counter.update_time_counter)

    hud.hide_life_counter()
    hud.hide_score_counter()
    hud.hide_time_counter()

    player.collector.note_collected.connect(game_run.add_note)
    player.collector.life_collected.connect(game_run.add_life)

    store_notes.call_deferred()

    Events.emit_player_unlocked_keys_changed(player.unlocked_keys)

func store_notes() -> void:
    for child in find_children("*", "", true, false):
        if child is Note:
            notes.append(child)

func pause() -> void:
    game_run.pause()

func resume() -> void:
    game_run.resume()

func open_on_player() -> void:
    camera_manager.jump_to(player_camera)
    player_camera.jump_to_target()
    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

func die() -> void:
    has_died.emit()

func finish() -> void:
    has_finished.emit()
