extends Level

class_name Level1

const RACE_NOTE_COMBO_DURATION: float = 3.0

@export var race_introduction_camera: Camera
@export var player_focus_camera: Camera

@export var soubalien: Soubalien
@export var soubalien_introduce_path: Path
@export var soubalien_chase_path: Path

@export var end_portal: Portal

@export var cinematic_bars: CinematicBars

@export var race_introduction_area: Area2D

@export var start_checkpoint: Checkpoint
@export var race_introduction_checkpoint: Checkpoint

var level_state: Level1State

func _ready() -> void:
    super._ready()

    start_checkpoint.checkpoint_pre_loaded.connect(on_start_checkpoint_pre_load)

    race_introduction_checkpoint.checkpoint_pre_loaded.connect(on_race_introduction_checkpoint_pre_load)
    race_introduction_checkpoint.checkpoint_loaded.connect(on_race_introduction_checkpoint_load)

    end_portal.spawn()
    end_portal.player_captured.connect(on_player_finished)

    player.collector.note_collected.connect(func(): Events.emit_note_collected())

    checkpoint_manager.load()

func on_start_checkpoint_pre_load() -> void:
    if level_state != null:
        level_state.queue_free()
        level_state = null

    level_state = Level1State.create_level_state(self)
    level_state.start()
    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()
    level_state.reveal()

func on_race_introduction_checkpoint_pre_load() -> void:
    if level_state != null:
        level_state.queue_free()
        level_state = null

    level_state = Level1State.create_level_state(self)
    level_state.pre_start_race()
    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

func on_race_introduction_checkpoint_load() -> void:
    level_state.start_race()

func on_player_captured() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    level_state.capture_player()
    release.call_deferred()

func on_player_finished() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    level_state.finish()
    finish()
    release.call_deferred()

func on_ray_captured_player() -> void:
    level_state.ray_capture_player()