extends Area2D

class_name CameraOverrideArea

@export var camera: Camera

@export var zoom: float = 1.0

var tween: Tween

func _ready() -> void:
    body_entered.connect(on_body_entered)
    body_exited.connect(on_body_exited)

func on_body_entered(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    camera.change_target(self)
    camera.zoom_to(Vector2(zoom, zoom), 0.5)

func on_body_exited(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    camera.restore_target()
    camera.zoom_to(Vector2(1, 1), 0.5)