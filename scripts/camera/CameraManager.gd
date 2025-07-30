extends Node

class_name CameraManager

@export var current_camera: Camera2D

func fly_to(destination_camera: Camera2D):
    var zoom = destination_camera.zoom
    var drag_left_margin = destination_camera.drag_left_margin
    var drag_right_margin = destination_camera.drag_right_margin

    destination_camera.drag_left_margin_target = drag_left_margin
    destination_camera.drag_right_margin_target = drag_right_margin

    destination_camera.zoom = current_camera.zoom
    destination_camera.zoom_target = zoom
    destination_camera.global_position = current_camera.get_screen_center_position() - destination_camera.offset

    destination_camera.make_current()

    current_camera = destination_camera

func jump_to(destination_camera: Camera2D):
    destination_camera.jump_to_target()
    destination_camera.make_current()
    await get_tree().create_timer(0.01).timeout

    current_camera = destination_camera
