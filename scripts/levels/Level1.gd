extends Level

class_name Level1

@export var player: ProjectileCharacter

@export var camera_manager: CameraManager
@export var player_camera: Camera
@export var race_introduction_camera: Camera
@export var player_focus_camera: Camera

@export var soubalien: Soubalien
@export var soubalien_introduce_path: Path
@export var soubalien_chase_path: Path

@export var transition_mask: TransitionMask

@export var end_portal: Portal

@export var countdown_animation_player: AnimationPlayer

@export var cinematic_bars: CinematicBars

@export var race_introduction_area: Area2D

@export var note_collector: NoteCollector

var collected_notes_index: int

@export var race_introduction_checkpoint: Checkpoint

func _ready() -> void:
    super._ready()

    reveal_hud()

    checkpoint_manager.checkpoint_saved.connect(func(): collected_notes_index = note_collector.collected_notes.size())
    checkpoint_manager.checkpoint_loaded.connect(func(): note_collector.restore(collected_notes_index))

    note_collector.note_collected.connect(func(value: int): add_score(value))

    race_introduction_checkpoint.checkpoint_pre_loaded.connect(race_introduction_checkpoint_preload)
    race_introduction_checkpoint.checkpoint_loaded.connect(race_introduction_checkpoint_load)

    camera_manager.jump_to(player_camera)

    transition_mask.transition_out(player)

    end_portal.spawn()
    end_portal.player_captured.connect(on_player_finished)

    soubalien.visible = false
    soubalien.process_mode = Node.PROCESS_MODE_DISABLED
    race_introduction_area.body_entered.connect(introduce_race)

func introduce_race(_body: Node2D) -> void:
    race_introduction_area.body_entered.disconnect(introduce_race)

    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
    # TODO : Play surprise animation
    await get_tree().create_timer(1.0).timeout

    unreveal_hud()
    cinematic_bars.reveal()
    camera_manager.fly_to(race_introduction_camera)

    soubalien.visible = true
    soubalien.process_mode = Node.PROCESS_MODE_INHERIT

    soubalien_introduce_path.call_deferred("set_child", soubalien)
    race_introduction_camera.set_target(soubalien)
    await soubalien_introduce_path.start()

    race_introduction_camera.set_target(player)

    start_chase()

func start_chase() -> void:
    soubalien_chase_path.call_deferred("set_child", soubalien)
    soubalien_chase_path.reset()

    await get_tree().create_timer(1.5).timeout

    soubalien.captured_player.connect(on_player_captured)
    soubalien.ray_captured_player.connect(on_ray_captured_player)

    cinematic_bars.unreveal()

    countdown_animation_player.play("countdown")
    await countdown_animation_player.animation_finished

    camera_manager.fly_to(player_camera)
    reveal_hud()

    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = true

    soubalien_chase_path.start()

func end_game() -> void:
    wants_to_load_level.emit("TitleScreen")

func race_introduction_checkpoint_preload() -> void:
    soubalien_chase_path.reset()
    race_introduction_camera.set_target(player)
    await camera_manager.jump_to(race_introduction_camera)
    transition_mask.transition_out(race_introduction_checkpoint.portal)

func race_introduction_checkpoint_load() -> void:
    start_chase()

func on_player_captured() -> void:
    soubalien.captured_player.disconnect(on_player_captured)
    soubalien.ray_captured_player.disconnect(on_ray_captured_player)
    await transition_mask.transition_in(player)
    soubalien.restore_player()
    checkpoint_manager.load()

func on_player_finished() -> void:
    await transition_mask.transition_in(player)
    end_game()

func on_ray_captured_player() -> void:
    unreveal_hud()
    cinematic_bars.reveal()
    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
    soubalien_chase_path.stop()
    camera_manager.fly_to(player_focus_camera)
