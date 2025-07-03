extends CanvasItem

class_name TransitionMask

@export var target: Node2D

var screen_position: Vector2

func _ready() -> void:
    var mask_radius = get_viewport_rect().size.length()
    material.set_shader_parameter("mask_radius", mask_radius)
    screen_position = target.get_global_transform_with_canvas().origin

func transition_in() -> void:
    var mask_radius = get_viewport_rect().size.length()
    material.set_shader_parameter("mask_radius", mask_radius)

    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/mask_radius", 0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

func transition_out() -> void:
    material.set_shader_parameter("mask_radius", 0)

    var mask_radius = get_viewport_rect().size.length()
    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/mask_radius", mask_radius, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

func _process(delta: float) -> void:
    var target_screen_position = target.get_global_transform_with_canvas().origin
    screen_position = lerp(screen_position, target_screen_position, delta * 10)
    material.set_shader_parameter("target_screen_position", screen_position)