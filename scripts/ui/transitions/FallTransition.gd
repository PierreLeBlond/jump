extends CanvasLayer

class_name FallTransition

@export var control: Control

@export var duration: float = 1.0

func transition_out() -> void:
    print("transition_out")
    var tween = create_tween()
    control.anchor_bottom = 0.0
    tween.tween_property(control, "anchor_bottom", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    await tween.finished
    print("transition_out finished")

func transition_in() -> void:
    var tween = create_tween()
    control.anchor_bottom = 1.0
    tween.tween_property(control, "anchor_bottom", 0.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    await tween.finished