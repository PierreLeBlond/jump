extends Node2D

class_name SoubaCoupe

signal captured_player(player: ProjectileCharacter)

@onready var area2d: Area2D = $Area2D

func on_body_entered(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    captured_player.emit(body)

func _ready() -> void:
    area2d.body_entered.connect(on_body_entered)