extends World

class_name World1

const NOTE_COMBO_DURATION: float = 0.7
const RACE_NOTE_COMBO_DURATION: float = 3.0

const COUNTDOWN_BPM: int = 160

@export var music_manager: MusicManager

@export var combo_note: ComboNote
@export var countdown_scene: PackedScene

@export var race_introduction_camera: Camera
@export var player_focus_camera: Camera

@export var soubalien_player_connector: SoubalienAndPlayerConnector
@export var soubalien: Soubalien
@export var soubalien_introduce_path: Path
@export var soubalien_chase_path: Path

@export var end_portal: Portal

@export var cinematic_bars: CinematicBars

@export var race_introduction_area: Area2D
@export var start_race_connector: StartRaceConnector

@export var start_checkpoint: Checkpoint
@export var race_introduction_checkpoint: Checkpoint

func _ready() -> void:
    super._ready()

    start_checkpoint.checkpoint_pre_loaded.connect(on_start_checkpoint_pre_load)
    start_checkpoint.checkpoint_loaded.connect(on_start_checkpoint_load)

    race_introduction_checkpoint.checkpoint_pre_loaded.connect(on_race_introduction_checkpoint_pre_load)
    race_introduction_checkpoint.checkpoint_loaded.connect(on_race_introduction_checkpoint_load)

    end_portal.spawn()
    end_portal.player_captured.connect(on_player_finished)

    game_run.combo_updated.connect(update_combo)

    synchronize_notes.call_deferred()

func synchronize_notes() -> void:
    var sorted_noted = notes.duplicate()
    sorted_noted.sort_custom(func(a: Note, b: Note): return a.global_position.x < b.global_position.x)
    for i in range(sorted_noted.size()):
        sorted_noted[i].offset_animation(0.2 if i % 2 == 0 else 0.7)

func update_combo(duration: float, count: int) -> void:
    music_manager.update_combo(duration, count)
    combo_note.update(duration, count)

func start() -> void:
    hud.hide_time_counter()
    hud.hide_life_counter()
    hud.hide_score_counter()

    game_run.combo_duration = NOTE_COMBO_DURATION

    soubalien.visible = false
    soubalien.process_mode = Node.PROCESS_MODE_DISABLED

    music_manager.start()

    race_introduction_area.body_entered.connect(introduce_race)

func reveal() -> void:
    hud.reveal_life_counter()
    hud.reveal_score_counter()

func introduce_race(_body: Node2D) -> void:
    music_manager.introduce_race()

    race_introduction_area.body_entered.disconnect(introduce_race)

    start_race_connector.trip()
    await get_tree().create_timer(1.0).timeout

    hud.unreveal_life_counter()
    hud.unreveal_score_counter()

    cinematic_bars.reveal()

    await get_tree().create_timer(1.0).timeout

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

    cinematic_bars.reveal()

    race_introduction_camera.set_target(player)
    camera_manager.jump_to(race_introduction_camera)

    soubalien_chase_path.call_deferred("set_child", soubalien)
    soubalien_player_connector.reset()
    soubalien_chase_path.reset()
    soubalien_chase_path.stop()

func start_race() -> void:
    start_race_connector.starting_block()
    race_introduction_camera.set_target(player)

    soubalien_chase_path.call_deferred("set_child", soubalien)
    soubalien_chase_path.reset()

    await get_tree().create_timer(1.5).timeout

    if !soubalien_player_connector.captured_player.is_connected(on_player_captured):
        soubalien_player_connector.captured_player.connect(on_player_captured)

    if !soubalien_player_connector.ray_captured_player.is_connected(on_ray_captured_player):
        soubalien_player_connector.ray_captured_player.connect(on_ray_captured_player)

    cinematic_bars.unreveal()

    var countdown = countdown_scene.instantiate()
    countdown.bpm = COUNTDOWN_BPM
    add_child(countdown)
    music_manager.start_countdown()

    synchronize_notes()

    await countdown.play()
    countdown.queue_free()

    camera_manager.fly_to(player_camera)

    game_run.reset_time()
    game_run.resume()

    hud.reveal_life_counter()
    hud.reveal_time_counter()
    hud.reveal_score_counter()

    start_race_connector.start()

    soubalien_chase_path.start()
    soubalien_player_connector.start_chasing_player()

    game_run.combo_duration = RACE_NOTE_COMBO_DURATION

func ray_capture_player() -> void:
    hud.unreveal_life_counter()
    hud.unreveal_score_counter()
    hud.unreveal_time_counter()

    cinematic_bars.reveal()
    player.lock_key(Globals.MOVE_UNLOCKED_KEY)
    soubalien_chase_path.stop()
    camera_manager.fly_to(player_focus_camera)

    game_run.remove_life()

func capture_player() -> void:
    soubalien_player_connector.captured_player.disconnect(on_player_captured)
    soubalien_player_connector.ray_captured_player.disconnect(on_ray_captured_player)
    soubalien_player_connector.reset()

    music_manager.end_race()

    die()

func reach_end() -> void:
    soubalien_chase_path.stop()
    soubalien_player_connector.captured_player.disconnect(on_player_captured)
    soubalien_player_connector.ray_captured_player.disconnect(on_ray_captured_player)

    music_manager.end_race()

func on_start_checkpoint_pre_load() -> void:
    start()

func on_start_checkpoint_load() -> void:
    reveal()

func on_race_introduction_checkpoint_pre_load() -> void:
    pre_start_race()

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
