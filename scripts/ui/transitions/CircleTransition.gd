extends CanvasLayer

class_name CircleTransition

@export var canvas_item: CanvasItem

var screen_position: Vector2

var current_target: Node2D = null

func _ready() -> void:
    var mask_radius = canvas_item.get_viewport_rect().size.length()
    canvas_item.material.set_shader_parameter("mask_radius", mask_radius)

func transition_out(target: Node2D) -> void:
    current_target = target
    visible = true

    var target_screen_position = get_viewport().get_stretch_transform() * current_target.get_global_transform_with_canvas().origin
    screen_position = target_screen_position
    canvas_item.material.set_shader_parameter("target_screen_position", screen_position)

    var mask_radius = canvas_item.get_viewport_rect().size.length()
    canvas_item.material.set_shader_parameter("mask_radius", mask_radius)

    var tween = create_tween()
    tween.tween_property(canvas_item.material, "shader_parameter/mask_radius", 0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

    current_target = null

func transition_in(target: Node2D) -> void:
    current_target = target

    var target_screen_position = get_viewport().get_stretch_transform() * current_target.get_global_transform_with_canvas().origin
    screen_position = target_screen_position
    canvas_item.material.set_shader_parameter("target_screen_position", screen_position)

    canvas_item.material.set_shader_parameter("mask_radius", 0)

    var mask_radius = canvas_item.get_viewport_rect().size.length()
    var tween = create_tween()
    tween.tween_property(canvas_item.material, "shader_parameter/mask_radius", mask_radius, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

    visible = false
    current_target = null

func _process(delta: float) -> void:
    if current_target == null:
        return

    var target_screen_position = get_viewport().get_stretch_transform() * current_target.get_global_transform_with_canvas().origin
    screen_position = lerp(screen_position, target_screen_position, delta * 10)
    canvas_item.material.set_shader_parameter("target_screen_position", screen_position)
