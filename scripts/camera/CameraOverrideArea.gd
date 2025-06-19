extends Area2D

class_name CameraOverrideArea

@export var camera: Camera2D

func _ready() -> void:
    body_entered.connect(on_body_entered)
    body_exited.connect(on_body_exited)

func on_body_entered(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    var tween = get_tree().create_tween()
    tween.tween_property(camera, "zoom", Vector2(0.5, 0.5), 0.5)
    tween.parallel().tween_property(camera, "position", position, 0.5)

func on_body_exited(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    var tween = get_tree().create_tween()
    tween.tween_property(camera, "zoom", Vector2(1, 1), 0.5)
    tween.parallel().tween_property(camera, "position:y", 256, 0.5)