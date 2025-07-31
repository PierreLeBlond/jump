extends Level

class_name Tutorial

@export var player: ProjectileCharacter

@export var hole: Area2D

@export var soubalien: Soubalien

@export var transition_mask: TransitionMask
@export var endPortal: Portal

func _ready() -> void:
    super._ready()

    hide_hud()

    hole.body_entered.connect(on_hole_body_entered)

    soubalien.captured_player.connect(on_player_captured)

    endPortal.spawn()
    endPortal.player_captured.connect(end_game)

    transition_mask.transition_out(player)
    load_checkpoint()

func end_game() -> void:
    await transition_mask.transition_in(player)

    wants_to_quit_to_main_menu.emit()

func on_hole_body_entered(_body: Node2D) -> void:
    load_checkpoint()

func on_player_captured() -> void:
    soubalien.restore_player()
    load_checkpoint()
