extends Area2D

class_name CameraOverrideArea

@export var camera: Camera

func _ready() -> void:
    body_entered.connect(on_body_entered)
    body_exited.connect(on_body_exited)

func on_body_entered(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    camera.zoom_to(Vector2(0.5, 0.5), 0.5, false)
    camera.move_to(position, 0.5, false)

func on_body_exited(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    camera.zoom_to(Vector2(1, 1), 0.5, false)