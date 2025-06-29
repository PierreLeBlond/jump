extends Node

class_name Tutorial

@onready var player: ProjectileCharacter = $Player
@onready var soubalien: Soubalien = $Soubalien
@onready var respawn_position: Node2D = $RespawnPosition

func _ready() -> void:
    soubalien.captured_player.connect(on_player_captured)

func on_player_captured() -> void:
    player.global_position = respawn_position.global_position

    # TODO: Find a better way of resetting the player
    player.velocity = Vector2.ZERO
    player.external_accelerations = {}
    player.set_collision_mask_value(1, true)
    player.scale = Vector2(1, 1)