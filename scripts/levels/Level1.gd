extends Level

class_name Level1

const NOTE_COMBO_DURATION: float = 1.0
const RACE_NOTE_COMBO_DURATION: float = 3.0

@export var race_introduction_camera: Camera
@export var player_focus_camera: Camera

@export var soubalien: Soubalien
@export var soubalien_introduce_path: Path
@export var soubalien_chase_path: Path

@export var end_portal: Portal

@export var countdown: Countdown

@export var combo_note: ComboNote

@export var cinematic_bars: CinematicBars

@export var race_introduction_area: Area2D

@export var race_introduction_checkpoint: Checkpoint

@export var event_dispatcher: EventDispatcher

func _ready() -> void:
    super._ready()

    race_introduction_checkpoint.checkpoint_pre_loaded.connect(race_introduction_checkpoint_preload)
    race_introduction_checkpoint.checkpoint_loaded.connect(race_introduction_checkpoint_load)

    camera_manager.jump_to(player_camera)

    end_portal.spawn()
    end_portal.player_captured.connect(on_player_finished)

    player.collector.combo_duration = NOTE_COMBO_DURATION
    player.collector.note_collected.connect(func(_count: int): event_dispatcher.note_collected.emit())
    player.collector.combo_updated.connect(func(duration: float, count: int): event_dispatcher.combo_updated.emit(duration, count))

    soubalien.visible = false
    soubalien.process_mode = Node.PROCESS_MODE_DISABLED
    race_introduction_area.body_entered.connect(introduce_race)

    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

    hud.hide_time_counter()
    show_hud()

func introduce_race(_body: Node2D) -> void:
    race_introduction_area.body_entered.disconnect(introduce_race)

    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
    await get_tree().create_timer(1.0).timeout

    hide_hud()
    cinematic_bars.reveal()
    camera_manager.fly_to(race_introduction_camera)

    soubalien.visible = true
    soubalien.process_mode = Node.PROCESS_MODE_INHERIT

    soubalien_introduce_path.call_deferred("set_child", soubalien)
    race_introduction_camera.set_target(soubalien)
    event_dispatcher.soubalien_appears.emit()
    await soubalien_introduce_path.start()

    player.collector.combo_duration = RACE_NOTE_COMBO_DURATION

    start_chase()

func start_chase() -> void:
    race_introduction_camera.set_target(player)

    soubalien_chase_path.call_deferred("set_child", soubalien)
    soubalien_chase_path.reset()

    await get_tree().create_timer(1.5).timeout

    if !soubalien.captured_player.is_connected(on_player_captured):
        soubalien.captured_player.connect(on_player_captured)

    if !soubalien.ray_captured_player.is_connected(on_ray_captured_player):
        soubalien.ray_captured_player.connect(on_ray_captured_player)

    cinematic_bars.unreveal()

    event_dispatcher.race_starts.emit()
    await countdown.play()

    game_run.reset_time()
    game_run.play()
    hud.show_time_counter()

    camera_manager.fly_to(player_camera)
    show_hud()

    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = true

    soubalien_chase_path.start()

func race_introduction_checkpoint_preload() -> void:
    hide_hud()
    cinematic_bars.reveal()
    soubalien_chase_path.reset()
    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
    soubalien_chase_path.stop()

func race_introduction_checkpoint_load() -> void:
    await camera_manager.fly_to(race_introduction_camera)
    start_chase()

func on_player_captured() -> void:
    soubalien.captured_player.disconnect(on_player_captured)
    soubalien.ray_captured_player.disconnect(on_ray_captured_player)
    event_dispatcher.race_ends.emit()

    var release = await Transition.create_circle_transition_out(get_tree().root, player)

    soubalien.restore_player()
    die()
    release.call_deferred()

func on_player_finished() -> void:
    soubalien_chase_path.stop()
    soubalien.captured_player.disconnect(on_player_captured)
    soubalien.ray_captured_player.disconnect(on_ray_captured_player)
    event_dispatcher.race_ends.emit()

    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    # load_level("Level2")
    finish()
    release.call_deferred()

func on_ray_captured_player() -> void:
    hide_hud()
    cinematic_bars.reveal()
    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
    soubalien_chase_path.stop()
    camera_manager.fly_to(player_focus_camera)
