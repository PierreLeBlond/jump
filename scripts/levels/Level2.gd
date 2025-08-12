extends Level

class_name Level2

@export var race_introduction_camera: Camera
@export var player_focus_camera: Camera

@export var soubalien: Soubalien
@export var soubalien_introduce_path: Path
@export var soubalien_chase_path: Path

@export var void_zone: Void

@export var end_portal: Portal

@export var countdown_animation_player: AnimationPlayer

@export var cinematic_bars: CinematicBars

@export var race_introduction_area: Area2D

@export var race_introduction_checkpoint: Checkpoint

func _ready() -> void:
    super._ready()

    void_zone.target_entered.connect(on_void_entered)

    race_introduction_checkpoint.checkpoint_pre_loaded.connect(race_introduction_checkpoint_preload)
    race_introduction_checkpoint.checkpoint_loaded.connect(race_introduction_checkpoint_load)

    camera_manager.jump_to(player_camera)

    end_portal.spawn()
    end_portal.player_captured.connect(on_player_finished)

    soubalien.visible = false
    soubalien.process_mode = Node.PROCESS_MODE_DISABLED
    race_introduction_area.body_entered.connect(introduce_race)

    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

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
    await soubalien_introduce_path.start()

    race_introduction_camera.set_target(player)

    start_chase()

func start_chase() -> void:
    soubalien_chase_path.call_deferred("set_child", soubalien)
    soubalien_chase_path.reset()

    await get_tree().create_timer(1.5).timeout

    if !soubalien.captured_player.is_connected(on_player_captured):
        soubalien.captured_player.connect(on_player_captured)

    if !soubalien.ray_captured_player.is_connected(on_ray_captured_player):
        soubalien.ray_captured_player.connect(on_ray_captured_player)

    cinematic_bars.unreveal()

    countdown_animation_player.play("countdown")
    await countdown_animation_player.animation_finished

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
    race_introduction_camera.set_target(player)
    await camera_manager.jump_to(race_introduction_camera)

func race_introduction_checkpoint_load() -> void:
    start_chase()

func on_player_captured() -> void:
    soubalien.captured_player.disconnect(on_player_captured)
    soubalien.ray_captured_player.disconnect(on_ray_captured_player)
    var release = await Transition.create_circle_transition_out(get_tree().root, player)

    soubalien.restore_player()
    die()
    release.call_deferred()

func on_player_finished() -> void:
    soubalien_chase_path.stop()
    soubalien.captured_player.disconnect(on_player_captured)
    soubalien.ray_captured_player.disconnect(on_ray_captured_player)

    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    finish()
    release.call_deferred()

func on_ray_captured_player() -> void:
    hide_hud()
    cinematic_bars.reveal()
    player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
    soubalien_chase_path.stop()
    camera_manager.fly_to(player_focus_camera)

func on_void_entered(_body: Node2D) -> void:
    var release = await Transition.create_fall_transition_out(get_tree().root)
    die()
    release.call_deferred()