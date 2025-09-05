extends Node

class_name Fly

@export var x: float = 0.0
@export var y: float = 0.0

@export var duration: float = 1.0

@export var delay: float = 0.0

func _ready() -> void:
    transition_in()

func transition_in() -> void:
    await get_tree().process_frame

    var parent = get_parent()

    if !parent:
        return

    var start_position = parent.position

    parent.position = Vector2(parent.position.x + x, parent.position.y + y)
    parent.modulate.a = 0.0

    if delay > 0.0:
        await get_tree().create_timer(delay).timeout

    var tween = create_tween()

    tween.tween_property(parent, "position", start_position, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.parallel().tween_property(parent, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

    await tween.finished
