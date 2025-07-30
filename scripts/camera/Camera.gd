extends Camera2D

class_name Camera

@export var vertical_speed: float = 1.0
@export var horizontal_speed: float = 2.0
@export var zoom_speed: float = 1.0
@export var drag_margin_speed: float = 1.0

@export var follow_vertical_on_jump: bool = false

@export var target: Node2D

var zoom_target: Vector2 = Vector2(1.0, 1.0)
var drag_left_margin_target: float = 0.0
var drag_right_margin_target: float = 0.0

var target_position: Vector2

func _ready() -> void:
    drag_left_margin_target = drag_left_margin
    drag_right_margin_target = drag_right_margin

    zoom_target = zoom

    jump_to_target()

func set_target(value: Node2D) -> void:
    target = value

func jump_to_target():
    global_position = target.global_position
    target_position = global_position

func _physics_process(delta: float) -> void:
    target_position.x = target.global_position.x
    if follow_vertical_on_jump || (target is ProjectileCharacter && target.is_on_floor()) || (target is ProjectileCharacter && target.velocity.y > 0 && global_position.y < target.global_position.y):
        target_position.y = target.global_position.y

    global_position.x = lerp(global_position.x, target_position.x, horizontal_speed * delta)
    global_position.y = lerp(global_position.y, target_position.y, vertical_speed * delta)

    # WARNING: Since we don't track the initial zoom and drag values, if switching cameras happens too fast, we will lose those values

    zoom = lerp(zoom, zoom_target, zoom_speed * delta)

    drag_left_margin = lerp(drag_left_margin, drag_left_margin_target, drag_margin_speed * delta)
    drag_right_margin = lerp(drag_right_margin, drag_right_margin_target, drag_margin_speed * delta)
