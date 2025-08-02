extends CanvasItem

class_name TransitionMask

var screen_position: Vector2

var current_target: Node2D = null

func _ready() -> void:
    var mask_radius = get_viewport_rect().size.length()
    material.set_shader_parameter("mask_radius", mask_radius)

func transition_in(target: Node2D) -> void:
    current_target = target
    visible = true

    var target_screen_position = current_target.get_global_transform_with_canvas().origin
    screen_position = target_screen_position
    material.set_shader_parameter("target_screen_position", screen_position)

    var mask_radius = get_viewport_rect().size.length()
    material.set_shader_parameter("mask_radius", mask_radius)

    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/mask_radius", 0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

    current_target = null

func transition_out(target: Node2D) -> void:
    current_target = target

    var target_screen_position = current_target.get_global_transform_with_canvas().origin
    screen_position = target_screen_position
    material.set_shader_parameter("target_screen_position", screen_position)

    material.set_shader_parameter("mask_radius", 0)

    var mask_radius = get_viewport_rect().size.length()
    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/mask_radius", mask_radius, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

    visible = false
    current_target = null

func _process(delta: float) -> void:
    if current_target == null:
        return

    var target_screen_position = current_target.get_global_transform_with_canvas().origin
    screen_position = lerp(screen_position, target_screen_position, delta * 10)
    material.set_shader_parameter("target_screen_position", screen_position)
