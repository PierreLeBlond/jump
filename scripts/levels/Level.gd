extends Node

class_name Level

signal wants_to_quit()
signal wants_to_restart()

signal has_run_out_of_lives()
signal has_finished(game_run: GameRun)

@export var player: ProjectileCharacter
@export var player_camera: Camera

@export var pause_manager: PauseManager
@export var camera_manager: CameraManager
@export var checkpoint_manager: CheckpointManager

@export var game_run: GameRun

@export var hud: HUD

func _ready() -> void:
    pause_manager.paused.connect(pause)
    pause_manager.resumed.connect(resume)

    pause_manager.wants_to_load_checkpoint.connect(load_checkpoint)
    pause_manager.wants_to_restart.connect(restart)
    pause_manager.wants_to_quit.connect(quit)

    game_run.life_changed.connect(hud.life_counter.update_counter)
    game_run.score_changed.connect(hud.score_counter.update_counter)
    game_run.time_changed.connect(hud.time_counter.update_time_counter)

    hud.life_counter.update_counter(game_run.life)
    hud.score_counter.update_counter(game_run.score)
    hud.time_counter.update_time_counter(game_run.elapsed_time)

    hud.hide_life_counter()
    hud.hide_score_counter()
    hud.hide_time_counter()

    checkpoint_manager.activate_checkpoints(self)

    player.collector.note_collected.connect(game_run.add_note)
    player.collector.life_collected.connect(game_run.add_life)

func pause() -> void:
    game_run.pause()

func resume() -> void:
    game_run.resume()

func load_checkpoint() -> void:
    checkpoint_manager.load()
    await camera_manager.jump_to(player_camera)
    var release = await Transition.create_circle_transition_in(get_tree().root, checkpoint_manager.current_checkpoint.portal)
    release.call_deferred()

func quit() -> void:
    wants_to_quit.emit()

func restart() -> void:
    wants_to_restart.emit()

func die() -> void:
    if game_run.life > 1:
        game_run.remove_life()
        load_checkpoint()
    else:
        has_run_out_of_lives.emit()

func finish() -> void:
    has_finished.emit(game_run)
