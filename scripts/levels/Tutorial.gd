extends Node

class_name Tutorial

@onready var souba_coupe: SoubaCoupe = $SoubaCoupe
@onready var respawn_position: Node2D = $RespawnPosition

func _ready() -> void:
    souba_coupe.captured_player.connect(on_player_captured)

func on_player_captured(player: ProjectileCharacter) -> void:
    player.global_position = respawn_position.global_position
    player.set_collision_mask_value(1, true)
    player.scale = Vector2(1, 1)