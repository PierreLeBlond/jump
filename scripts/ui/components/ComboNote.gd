extends Control

class_name ComboNote

@export var target: Node2D
@export var offset: Vector2 = Vector2.ZERO

@export var combo_label: Label
@export var texture_range: Range

@export var event_dispatcher: EventDispatcher

var tween: Tween

func _ready() -> void:
    hide()
    event_dispatcher.combo_updated.connect(on_combo_updated)

func _process(_delta: float) -> void:
    global_position = target.get_global_transform().origin + offset

func on_combo_updated(duration: float, count: int) -> void:
    update(duration, count)

func update(duration: float, count: int) -> void:
    if tween:
        tween.stop()
        tween = null

    texture_range.value = 100.0
    tween = create_tween()
    tween.tween_property(texture_range, "value", 0.0, duration)
    tween.finished.connect(on_tween_finished)
    show()

    combo_label.text = str(count)

func on_tween_finished() -> void:
    combo_label.text = str(0)
    hide()