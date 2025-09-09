extends Node

class_name Level1State

const NOTE_COMBO_DURATION: float = 0.7
const RACE_NOTE_COMBO_DURATION: float = 3.0

const COUNTDOWN_BPM: int = 108

@export var combo_note: ComboNote
@export var countdown_scene: PackedScene

var level: Level1

# Note: This class should be used to store all level elements, cutscenes, async scripts, etc, 
# that should be canceled anytime we reload the level, just by deleting the level state instance.
# A new instance can be created at any time to resume the level, e.g. at different checkpoints.

static func create_level_state(parent_level: Level1) -> Level1State:
    var level_state: Level1State = load("res://scenes/levels/Level1/Level1State.tscn").instantiate()
    level_state.level = parent_level

    level_state.combo_note.target = parent_level.player

    parent_level.add_child(level_state)

    return level_state

func start() -> void:
    level.hud.hide_time_counter()
    level.hud.hide_life_counter()
    level.hud.hide_score_counter()

    level.player_camera.jump_to_target()
    level.camera_manager.jump_to(level.player_camera)

    level.game_run.combo_duration = NOTE_COMBO_DURATION

    level.soubalien.visible = false
    level.soubalien.process_mode = Node.PROCESS_MODE_DISABLED
    level.race_introduction_area.body_entered.connect(introduce_race)

func reveal() -> void:
    level.hud.reveal_life_counter()
    level.hud.reveal_score_counter()

func introduce_race(_body: Node2D) -> void:
    Events.emit_soubalien_appears()
    level.race_introduction_area.body_entered.disconnect(introduce_race)

    level.player.lock_key(Globals.MOVE_UNLOCKED_KEY)
    await get_tree().create_timer(1.0).timeout

    level.hud.unreveal_life_counter()
    level.hud.unreveal_score_counter()

    level.cinematic_bars.reveal()
    level.camera_manager.fly_to(level.race_introduction_camera)

    level.soubalien.visible = true
    level.soubalien.process_mode = Node.PROCESS_MODE_INHERIT

    level.soubalien_introduce_path.call_deferred("set_child", level.soubalien)
    level.race_introduction_camera.set_target(level.soubalien)
    await level.soubalien_introduce_path.start()

    start_race()

func pre_start_race() -> void:
    level.hud.unreveal_life_counter()
    level.hud.unreveal_score_counter()
    level.hud.unreveal_time_counter()

    level.player.lock_key(Globals.MOVE_UNLOCKED_KEY)

    level.cinematic_bars.reveal()

    # Warning: Avoid camera jump when starting level with race checkpoint. Unfortunatelly we don't know why.
    level.camera_manager.jump_to(level.player_camera)

    level.race_introduction_camera.set_target(level.player)
    level.camera_manager.jump_to(level.race_introduction_camera)

    level.soubalien_chase_path.call_deferred("set_child", level.soubalien)
    level.soubalien.reset()
    level.soubalien_chase_path.reset()
    level.soubalien_chase_path.stop()

func start_race() -> void:
    Events.emit_race_pre_starts()

    level.race_introduction_camera.set_target(level.player)

    level.soubalien_chase_path.call_deferred("set_child", level.soubalien)
    level.soubalien_chase_path.reset()

    await get_tree().create_timer(1.5).timeout

    if !level.soubalien.captured_player.is_connected(level.on_player_captured):
        level.soubalien.captured_player.connect(level.on_player_captured)

    if !level.soubalien.ray_captured_player.is_connected(level.on_ray_captured_player):
        level.soubalien.ray_captured_player.connect(level.on_ray_captured_player)

    level.cinematic_bars.unreveal()

    Events.emit_countdown_starts()
    var countdown = countdown_scene.instantiate()
    countdown.bpm = COUNTDOWN_BPM
    add_child(countdown)
    await countdown.play()
    countdown.queue_free()

    level.camera_manager.fly_to(level.player_camera)

    level.game_run.reset_time()
    level.game_run.resume()

    level.hud.reveal_life_counter()
    level.hud.reveal_time_counter()
    level.hud.reveal_score_counter()

    level.player.unlock_key(Globals.MOVE_UNLOCKED_KEY)

    level.soubalien_chase_path.start()

    level.game_run.combo_duration = RACE_NOTE_COMBO_DURATION

    Events.emit_race_starts()

func ray_capture_player() -> void:
    await get_tree().create_timer(1.0).timeout

    level.hud.unreveal_life_counter()
    level.hud.unreveal_score_counter()
    level.hud.unreveal_time_counter()

    level.cinematic_bars.reveal()
    level.player.lock_key(Globals.MOVE_UNLOCKED_KEY)
    level.soubalien_chase_path.stop()
    level.camera_manager.fly_to(level.player_focus_camera)

func capture_player() -> void:
    level.soubalien.captured_player.disconnect(level.on_player_captured)
    level.soubalien.ray_captured_player.disconnect(level.on_ray_captured_player)
    Events.emit_race_ends()

    level.soubalien.reset()
    level.die()

func finish() -> void:
    level.soubalien_chase_path.stop()
    level.soubalien.captured_player.disconnect(level.on_player_captured)
    level.soubalien.ray_captured_player.disconnect(level.on_ray_captured_player)
    Events.emit_race_ends()
