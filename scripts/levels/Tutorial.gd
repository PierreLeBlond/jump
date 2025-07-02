extends Node

class_name Tutorial

@onready var player: ProjectileCharacter = $Player
@onready var soubalien: Soubalien = $Soubalien
@onready var respawn_position: Node2D = $RespawnPosition

@export var transition_mask: TransitionMask

func _ready() -> void:
    soubalien.captured_player.connect(on_player_captured)
    transition_mask.transition_out()

func on_player_captured() -> void:
    player.global_position = respawn_position.global_position

    # TODO: Find a better way of resetting the player
    player.external_accelerations = {}
    player.set_collision_mask_value(1, true)
    player.scale = Vector2(1, 1)


    await transition_mask.transition_out()
