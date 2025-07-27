extends Camera2D

class_name Camera

@export var player: ProjectileCharacter

@export var default_vertical_speed: float = 1.0
@export var focused_vertical_speed: float = 3.0
@export var horizontal_speed: float = 2.0

var vertical_speed: float = default_vertical_speed

@export var follow_vertical_on_jump: bool = false

var target: Node2D

var zoom_tween: Tween
var offset_tween: Tween
var position_tween: Tween

var cutscene_camera: Camera2D

var target_position: Vector2

func _ready() -> void:
  target = player

func zoom_to(value: Vector2, duration: float) -> void:
  if zoom_tween != null:
    zoom_tween.kill()

  zoom_tween = create_tween()
  zoom_tween.tween_property(self, "zoom", value, duration)
  await zoom_tween.finished

func offset_to(value: Vector2, duration: float) -> void:
  if offset_tween != null:
    offset_tween.kill()

  offset_tween = create_tween()
  offset_tween.tween_property(self, "offset", value, duration)
  await offset_tween.finished

func change_target(value: Node2D) -> void:
  target = value

func restore_target() -> void:
  target = player


func switch_to_main_camera() -> void:
  if cutscene_camera == null:
    return

  var screen_center_position = get_screen_center_position()

  var tween = create_tween()
  tween.tween_property(cutscene_camera, "position", screen_center_position, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  tween.parallel().tween_property(cutscene_camera, "zoom", zoom, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
  tween.tween_callback(func():
    cutscene_camera.queue_free()
    cutscene_camera = null
    make_current()
  )
  await tween.finished

func focus(duration: float):
  zoom_to(Vector2(2, 2), duration)
  offset_to(Vector2(0, 0), duration)
  follow_vertical_on_jump = true
  vertical_speed = focused_vertical_speed

func unfocus(duration: float):
  zoom_to(Vector2(1, 1), duration)
  offset_to(Vector2(512, 0), duration)
  follow_vertical_on_jump = false
  vertical_speed = default_vertical_speed

func jump_to_target():
  global_position = target.global_position

func _physics_process(delta: float) -> void:
  target_position.x = target.global_position.x
  if follow_vertical_on_jump || player.is_on_floor() || (player.velocity.y > 0 && global_position.y < target.global_position.y):
    target_position.y = target.global_position.y

  global_position.x = lerp(global_position.x, target_position.x, horizontal_speed * delta)
  global_position.y = lerp(global_position.y, target_position.y, vertical_speed * delta)
