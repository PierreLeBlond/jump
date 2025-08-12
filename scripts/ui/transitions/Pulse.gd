extends Node

class_name Pulse

@export var duration: float = 1.0

@export var delay: float = 0.0

func _enter_tree() -> void:
    transition_in()

func transition_in() -> void:
    await get_tree().process_frame

    var parent = get_parent()

    if !parent:
        return

    var modulate = parent.modulate

    parent.modulate.a = 0.0

    if delay > 0.0:
        await get_tree().create_timer(delay).timeout

    var tween = create_tween()

    tween.set_loops()
    tween.tween_property(parent, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(parent, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

    await tween.finished
