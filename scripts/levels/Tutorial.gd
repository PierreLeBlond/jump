extends Node

class_name Tutorial

@export var player: ProjectileCharacter

@export var hole: Area2D

@export var soubalien: Soubalien

@export var transition_mask: TransitionMask
@export var endPortal: Portal

@export var start_checkpoint: Checkpoint
@export var hole_checkpoint: Checkpoint
@export var soubalien_checkpoint: Checkpoint

var last_checkpoint: Checkpoint

func _ready() -> void:
    hole_checkpoint.checkpoint_saved.connect(set_last_checkpoint)
    soubalien_checkpoint.checkpoint_saved.connect(set_last_checkpoint)

    hole.body_entered.connect(on_hole_body_entered)

    soubalien.captured_player.connect(on_player_captured)

    endPortal.spawn()
    endPortal.player_captured.connect(end_game)

    transition_mask.transition_out()
    last_checkpoint = start_checkpoint
    last_checkpoint.load()

func set_last_checkpoint(checkpoint: Checkpoint) -> void:
    last_checkpoint = checkpoint

func end_game() -> void:
    await transition_mask.transition_in()

    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/levels/TitleScreen.tscn")

func on_hole_body_entered(_body: Node2D) -> void:
    last_checkpoint.load()

func on_player_captured() -> void:
    soubalien.restore_player()
    last_checkpoint.load()
