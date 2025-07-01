extends CanvasItem

class_name TransitionMask

func _ready() -> void:
    var mask_radius = get_viewport_rect().size.length()
    material.set_shader_parameter("mask_radius", mask_radius)

func transition_in(target: Node2D) -> void:
    var target_screen_position = target.get_global_transform_with_canvas().origin
    material.set_shader_parameter("target_screen_position", target_screen_position)

    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/mask_radius", 0, 1.0)
    await tween.finished

func transition_out(target: Node2D) -> void:
    var target_screen_position = target.get_global_transform_with_canvas().origin
    material.set_shader_parameter("target_screen_position", target_screen_position)

    material.set_shader_parameter("mask_radius", 0)

    var mask_radius = get_viewport_rect().size.length()
    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/mask_radius", mask_radius, 1.0)
    await tween.finished