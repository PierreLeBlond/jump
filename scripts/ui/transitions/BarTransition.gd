extends CanvasLayer

class_name BarTransition

@export var bars: Array[Control]
@export var bar_delays: Array[float]

@export var duration: float = 1.0

signal single_transition_finished()
signal all_transitions_finished()

var finished_transitions: int = 0

func _ready() -> void:
    single_transition_finished.connect(func():
        finished_transitions += 1
        if finished_transitions == bars.size():
            all_transitions_finished.emit()
    )

func transition_bar(bar: Control, property: String, source: float, target: float, delay: float) -> void:
    var tween = create_tween()
    bar.set(property, source)
    tween.tween_property(bar, property, target, duration).set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    await tween.finished
    single_transition_finished.emit()

func transition_left_out() -> void:
    for i in range(bars.size()):
        transition_bar(bars[i], "anchor_right", 0.0, 1.0, bar_delays[i])
    await all_transitions_finished

func transition_left_in() -> void:
    for i in range(bars.size()):
        transition_bar(bars[i], "anchor_right", 1.0, 0.0, bar_delays[i])
    await all_transitions_finished

func transition_right_out() -> void:
    for i in range(bars.size()):
        transition_bar(bars[i], "anchor_left", 1.0, 0.0, bar_delays[i])
    await all_transitions_finished

func transition_right_in() -> void:
    for i in range(bars.size()):
        transition_bar(bars[i], "anchor_left", 0.0, 1.0, bar_delays[i])
    await all_transitions_finished