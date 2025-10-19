extends Node

class_name CameraManager

@export var current_camera: Camera2D

func fly_to(destination_camera: Camera2D):
    var zoom = destination_camera.zoom

    destination_camera.zoom = current_camera.zoom
    destination_camera.zoom_target = zoom

    # When a camera is not the current one, screen center position is not updated from global position
    destination_camera.make_current()

    destination_camera.global_position = current_camera.get_screen_center_position() - destination_camera.offset

    current_camera = destination_camera

func jump_to(destination_camera: Camera2D):
    destination_camera.jump_to_target()
    destination_camera.make_current()
    await get_tree().create_timer(0.01).timeout

    current_camera = destination_camera
