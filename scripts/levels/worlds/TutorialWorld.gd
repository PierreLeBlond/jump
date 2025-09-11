extends World

class_name TutorialWorld

@export var soubalien: Soubalien
@export var void_zone: Void

@export var endPortal: Portal

@export var start_checkpoint: Checkpoint
@export var hole_checkpoint: Checkpoint
@export var soubalien_checkpoint: Checkpoint

func _ready() -> void:
    super._ready()

    void_zone.target_entered.connect(on_void_entered)

    soubalien.captured_player.connect(on_player_captured)

    endPortal.spawn()
    endPortal.player_captured.connect(end_game)

    soubalien.start_chasing_player()

    hole_checkpoint.checkpoint_pre_loaded.connect(on_hole_checkpoint_pre_load)
    start_checkpoint.checkpoint_pre_loaded.connect(on_start_checkpoint_pre_load)
    soubalien_checkpoint.checkpoint_pre_loaded.connect(on_soubalien_checkpoint_pre_load)

func on_start_checkpoint_pre_load() -> void:
    camera_manager.jump_to(player_camera)
    player_camera.jump_to_target()

    player.lock_key(Globals.MOVE_UNLOCKED_KEY)
    player.lock_key(Globals.JUMP_UNLOCKED_KEY)
    player.lock_key(Globals.PAUSE_UNLOCKED_KEY)

    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

func on_hole_checkpoint_pre_load() -> void:
    camera_manager.jump_to(player_camera)
    player_camera.jump_to_target()
    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

func on_soubalien_checkpoint_pre_load() -> void:
    camera_manager.jump_to(player_camera)
    player_camera.jump_to_target()
    var release = await Transition.create_circle_transition_in(get_tree().root, player)
    release.call_deferred()

func on_void_entered(_body: Node2D) -> void:
    var release = await Transition.create_fall_transition_out(get_tree().root)
    die()
    release.call_deferred()

func on_player_captured() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    die()
    release.call_deferred()

func end_game() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    finish()
    release.call_deferred()
