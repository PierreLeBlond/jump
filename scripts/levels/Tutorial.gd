extends Node

class_name Tutorial

@onready var player: ProjectileCharacter = $Player
@onready var soubalien: Soubalien = $Soubalien
@onready var respawn_position: Node2D = $RespawnPosition

@export var transition_mask: TransitionMask
@export var endPortal: Portal
@export var spawnPortal: Portal

func _ready() -> void:
    soubalien.captured_player.connect(on_player_captured)

    endPortal.spawn()
    endPortal.player_captured.connect(end_game)

    transition_mask.transition_out()
    spawnPortal.release_player()

func end_game() -> void:
    await transition_mask.transition_in()

    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func on_player_captured() -> void:
    spawnPortal.global_position = respawn_position.global_position
    soubalien.restore_player()
    spawnPortal.release_player()
