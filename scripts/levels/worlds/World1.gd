extends World

class_name World1

const NOTE_COMBO_DURATION: float = 0.7
const RACE_NOTE_COMBO_DURATION: float = 3.0

const COUNTDOWN_BPM: int = 108

@export var combo_note: ComboNote
@export var countdown_scene: PackedScene

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

func _ready() -> void:
    super._ready()

    start_checkpoint.checkpoint_pre_loaded.connect(on_start_checkpoint_pre_load)

    race_introduction_checkpoint.checkpoint_pre_loaded.connect(on_race_introduction_checkpoint_pre_load)
    race_introduction_checkpoint.checkpoint_loaded.connect(on_race_introduction_checkpoint_load)

    end_portal.spawn()
    end_portal.player_captured.connect(on_player_finished)

    player.collector.note_collected.connect(func(): Events.emit_note_collected())

func start() -> void:
    hud.hide_time_counter()
    hud.hide_life_counter()
    hud.hide_score_counter()

    player_camera.jump_to_target()
    camera_manager.jump_to(player_camera)

    game_run.combo_duration = NOTE_COMBO_DURATION

    soubalien.visible = false
    soubalien.process_mode = Node.PROCESS_MODE_DISABLED

    race_introduction_area.body_entered.connect(introduce_race)

func reveal() -> void:
    hud.reveal_life_counter()
    hud.reveal_score_counter()

func introduce_race(_body: Node2D) -> void:
    Events.emit_soubalien_appears()
    race_introduction_area.body_entered.disconnect(introduce_race)

    player.lock_key(Globals.MOVE_UNLOCKED_KEY)
    await get_tree().create_timer(1.0).timeout

    hud.unreveal_life_counter()
    hud.unreveal_score_counter()

    cinematic_bars.reveal()
    camera_manager.fly_to(race_introduction_camera)

    soubalien.visible = true
    soubalien.process_mode = Node.PROCESS_MODE_INHERIT

    soubalien_introduce_path.call_deferred("set_child", soubalien)
    race_introduction_camera.set_target(soubalien)
    await soubalien_introduce_path.start()

    start_race()

func pre_start_race() -> void:
    hud.unreveal_life_counter()
    hud.unreveal_score_counter()
    hud.unreveal_time_counter()

    player.lock_key(Globals.MOVE_UNLOCKED_KEY)

    cinematic_bars.reveal()

    # Warning: Avoid camera jump when starting level with race checkpoint. Unfortunatelly we don't know why.
    camera_manager.jump_to(player_camera)

    race_introduction_camera.set_target(player)
    camera_manager.jump_to(race_introduction_camera)

    soubalien_chase_path.call_deferred("set_child", soubalien)
    soubalien.reset()
    soubalien_chase_path.reset()
    soubalien_chase_path.stop()

func start_race() -> void:
    Events.emit_race_pre_starts()

    race_introduction_camera.set_target(player)

    soubalien_chase_path.call_deferred("set_child", soubalien)
    soubalien_chase_path.reset()

    await get_tree().create_timer(1.5).timeout

    if !soubalien.captured_player.is_connected(on_player_captured):
        soubalien.captured_player.connect(on_player_captured)

    if !soubalien.ray_captured_player.is_connected(on_ray_captured_player):
        soubalien.ray_captured_player.connect(on_ray_captured_player)

    cinematic_bars.unreveal()

    Events.emit_countdown_starts()
    var countdown = countdown_scene.instantiate()
    countdown.bpm = COUNTDOWN_BPM
    add_child(countdown)
    await countdown.play()
    countdown.queue_free()

    camera_manager.fly_to(player_camera)

    game_run.reset_time()
    game_run.resume()

    hud.reveal_life_counter()
    hud.reveal_time_counter()
    hud.reveal_score_counter()

    player.unlock_key(Globals.MOVE_UNLOCKED_KEY)

    soubalien_chase_path.start()
    soubalien.start_chasing_player()

    game_run.combo_duration = RACE_NOTE_COMBO_DURATION

    Events.emit_race_starts()

func ray_capture_player() -> void:
    await get_tree().create_timer(1.0).timeout

    hud.unreveal_life_counter()
    hud.unreveal_score_counter()
    hud.unreveal_time_counter()

    cinematic_bars.reveal()
    player.lock_key(Globals.MOVE_UNLOCKED_KEY)
    soubalien_chase_path.stop()
    camera_manager.fly_to(player_focus_camera)

func capture_player() -> void:
    soubalien.captured_player.disconnect(on_player_captured)
    soubalien.ray_captured_player.disconnect(on_ray_captured_player)
    Events.emit_race_ends()

    soubalien.reset()
    die()

func reach_end() -> void:
    soubalien_chase_path.stop()
    soubalien.captured_player.disconnect(on_player_captured)
    soubalien.ray_captured_player.disconnect(on_ray_captured_player)
    Events.emit_race_ends()

func on_start_checkpoint_pre_load() -> void:
    start()
    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()
    reveal()

func on_race_introduction_checkpoint_pre_load() -> void:
    pre_start_race()
    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

func on_race_introduction_checkpoint_load() -> void:
    start_race()

func on_player_captured() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    capture_player()
    release.call_deferred()

func on_player_finished() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    reach_end()
    finish()
    release.call_deferred()

func on_ray_captured_player() -> void:
    ray_capture_player()
