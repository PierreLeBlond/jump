extends Camera2D

class_name Camera

@export var vertical_speed: float = 1.0
@export var horizontal_speed: float = 2.0

@export var follow_vertical_on_jump: bool = false

@export var target: Node2D

var zoom_tween: Tween
var offset_tween: Tween
var position_tween: Tween

var target_position: Vector2

func set_target(value: Node2D) -> void:
  target = value

func jump_to_target():
  global_position = target.global_position

func _physics_process(delta: float) -> void:
  target_position.x = target.global_position.x
  if follow_vertical_on_jump || (target is ProjectileCharacter && target.is_on_floor()) || (target is ProjectileCharacter && target.velocity.y > 0 && global_position.y < target.global_position.y):
    target_position.y = target.global_position.y

  global_position.x = lerp(global_position.x, target_position.x, horizontal_speed * delta)
  global_position.y = lerp(global_position.y, target_position.y, vertical_speed * delta)
