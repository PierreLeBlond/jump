extends CanvasLayer

class_name LoadingTransition

@export var canvas_item: CanvasItem

@export var duration: float = 0.5

func transition_in() -> void:
    canvas_item.modulate.a = 0
    var tween = create_tween()
    tween.tween_property(canvas_item, "modulate:a", 1, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    await tween.finished

func transition_out() -> void:
    canvas_item.modulate.a = 1
    var tween = create_tween()
    tween.tween_property(canvas_item, "modulate:a", 0, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
    await tween.finished