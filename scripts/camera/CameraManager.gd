extends Node

class_name CameraManager

var current_camera: Camera2D

var fly_tween: Tween

func fly_to(destination_camera: Camera2D):
  var zoom = destination_camera.zoom
  var offset = destination_camera.offset
  var drag_left_margin = destination_camera.drag_left_margin
  var drag_right_margin = destination_camera.drag_right_margin

  # Should reset drag margins to 0 to avoid camera jump, then set them back to the original values with the tween
  destination_camera.drag_left_margin = 0
  destination_camera.drag_right_margin = 0

  destination_camera.offset = current_camera.offset
  destination_camera.zoom = current_camera.zoom
  destination_camera.global_position = current_camera.get_screen_center_position() - current_camera.offset

  current_camera = destination_camera
  current_camera.make_current()

  if fly_tween != null:
    fly_tween.kill()
  fly_tween = create_tween()

  fly_tween.parallel().tween_property(current_camera, "zoom", zoom, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  fly_tween.parallel().tween_property(current_camera, "offset", offset, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  fly_tween.parallel().tween_property(current_camera, "drag_left_margin", drag_left_margin, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  fly_tween.parallel().tween_property(current_camera, "drag_right_margin", drag_right_margin, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

  await fly_tween.finished

func jump_to(destination_camera: Camera2D):
  current_camera = destination_camera
  current_camera.make_current()
  current_camera.reset_smoothing()
