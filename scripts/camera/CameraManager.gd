extends Node

class_name CameraManager

var current_camera: Camera2D

var fly_tween: Tween

func fly_to(destination_camera: Camera2D):
  # TODO: Set last camera settings to new camera
  current_camera = destination_camera
  current_camera.make_current()

  # Maybe use real screen position
  var position = current_camera.position
  var zoom = current_camera.zoom
  var offset = current_camera.offset

  if fly_tween != null:
    fly_tween.kill()
  fly_tween = create_tween()

  fly_tween.tween_property(current_camera, "position", position, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  fly_tween.parallel().tween_property(current_camera, "zoom", zoom, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  fly_tween.parallel().tween_property(current_camera, "offset", offset, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

  await fly_tween.animation_finished

func jump_to(destination_camera: Camera2D):
  current_camera = destination_camera
  current_camera.make_current()
  current_camera.reset_smoothing()