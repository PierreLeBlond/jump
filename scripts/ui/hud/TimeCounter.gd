extends Control

class_name TimeCounter

@export var control: Control
@export var time_label: Label

func update_time_counter(value: float) -> void:
    time_label.text = Utils.format_time(value)

func reveal() -> void:
    show()
    control.scale = Vector2(0.0, 0.0)
    var tween = create_tween()
    tween.tween_property(control, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func unreveal() -> void:
    var tween = create_tween()
    tween.tween_property(control, "scale", Vector2(0.0, 0.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
    await tween.finished
    hide()