extends World

class_name TutorialWorld

@export var soubalien: Soubalien
@export var void_zone: Void

@export var soubalien_player_connector: SoubalienAndPlayerConnector

@export var endPortal: Portal

@export var start_checkpoint: Checkpoint

func _ready() -> void:
    super._ready()

    void_zone.target_entered.connect(on_void_entered)

    soubalien_player_connector.captured_player.connect(on_player_captured)

    endPortal.spawn()
    endPortal.player_captured.connect(end_game)

    soubalien_player_connector.start_chasing_player()

    start_checkpoint.checkpoint_pre_loaded.connect(on_start_checkpoint_pre_load)

func on_start_checkpoint_pre_load() -> void:
    player.lock_key(Globals.MOVE_UNLOCKED_KEY)
    player.lock_key(Globals.JUMP_UNLOCKED_KEY)
    player.lock_key(Globals.PAUSE_UNLOCKED_KEY)

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
