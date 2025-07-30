extends Area2D

class_name CameraOverrideArea

@export var camera_manager: CameraManager

@export var restore_camera: Camera
@export var override_camera: Camera

var tween: Tween

func _ready() -> void:
    body_entered.connect(on_body_entered)
    body_exited.connect(on_body_exited)

func on_body_entered(body: Node2D) -> void:
    if body is not ProjectileCharacter:
        return

    camera_manager.fly_to(override_camera)

func on_body_exited(body: Node2D) -> void:
    if body is not ProjectileCharacter:
        return

    if override_camera != camera_manager.current_camera:
        return

    camera_manager.fly_to(restore_camera)
