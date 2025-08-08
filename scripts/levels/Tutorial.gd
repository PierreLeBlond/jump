extends Level

class_name Tutorial

@export var soubalien: Soubalien
@export var void_zone: Void

@export var endPortal: Portal

func _ready() -> void:
    super._ready()

    void_zone.target_entered.connect(on_void_entered)

    soubalien.captured_player.connect(on_player_captured)

    endPortal.spawn()
    endPortal.player_captured.connect(end_game)

    load_checkpoint()

func end_game() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    wants_to_quit_to_main_menu.emit()
    release.call_deferred()

func on_void_entered(_body: Node2D) -> void:
    var release = await Transition.create_fall_transition_out(get_tree().root)
    load_checkpoint()
    release.call_deferred()

func on_player_captured() -> void:
    var release = await Transition.create_circle_transition_out(get_tree().root, player)
    soubalien.restore_player()
    load_checkpoint()
    release.call_deferred()
