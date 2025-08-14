extends Control

class_name Counter

@export var control: Control
@export var counter_label: Label

func update_counter(value: int) -> void:
    if value < 10:
        counter_label.text = "0" + str(value)
    else:
        counter_label.text = str(value)

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