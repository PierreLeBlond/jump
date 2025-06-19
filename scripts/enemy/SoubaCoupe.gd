extends Node2D

class_name SoubaCoupe

signal captured_player

@export var speed: float = 100

@onready var area2d: Area2D = $Area2D

func on_body_entered(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    captured_player.emit()

func _ready() -> void:
    area2d.body_entered.connect(on_body_entered)

func _physics_process(delta: float) -> void:
    position += Vector2(speed * delta, 0)