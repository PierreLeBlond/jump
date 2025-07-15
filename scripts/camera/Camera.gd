extends Camera2D

class_name Camera

@export var player: ProjectileCharacter

@export var speed: float = 2.0

var is_zoom_locked = false
var is_position_locked = false

var zoom_tween: Tween
var position_tween: Tween

var cutscene_camera: Camera2D

var follow_position: Vector2 = Vector2.ZERO

func zoom_to(value: Vector2, duration: float, lock: bool) -> void:
  if is_zoom_locked:
    return

  if zoom_tween != null:
    zoom_tween.kill()

  zoom_tween = create_tween()
  zoom_tween.tween_property(self, "zoom", value, duration)
  if lock:
    is_zoom_locked = true
    zoom_tween.tween_callback(func(): is_zoom_locked = false)

func move_to(value: Vector2, duration: float, lock: bool) -> void:
  if is_position_locked:
    return

  if position_tween != null:
    position_tween.kill()

  position_tween = create_tween()
  position_tween.tween_property(self, "position", value, duration)

  await position_tween.finished

  if lock:
    is_position_locked = true
    position_tween.tween_callback(func(): is_position_locked = false)

func switch_to_cutscene_camera() -> Camera2D:
    if cutscene_camera != null:
      return cutscene_camera

    # TODO: Add properties to copy as needed
    cutscene_camera = Camera2D.new()
    cutscene_camera.position = get_screen_center_position()
    cutscene_camera.zoom = zoom
    cutscene_camera.limit_bottom = limit_bottom

    # TODO: Should the cutscene camera be put elsewhere in the tree?
    get_parent().add_child(cutscene_camera)
    cutscene_camera.make_current()

    return cutscene_camera

func switch_to_main_camera() -> void:
  if cutscene_camera == null:
    return

  var target_position = get_screen_center_position()

  var tween = create_tween()
  tween.tween_property(cutscene_camera, "position", target_position, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  tween.parallel().tween_property(cutscene_camera, "zoom", zoom, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  tween.tween_callback(func():
    cutscene_camera.queue_free()
    cutscene_camera = null
    make_current()
  )
  await tween.finished

func _physics_process(delta: float) -> void:
  global_position.x = lerp(global_position.x, player.global_position.x, speed * delta)
  if player.is_on_floor() || (player.velocity.y >= 0 && global_position.y < player.global_position.y):
    global_position.y = lerp(global_position.y, player.global_position.y, speed / 2 * delta)
