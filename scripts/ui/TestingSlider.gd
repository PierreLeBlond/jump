extends Node

class_name TestingSlider

@export var label: String

@export var min_value: float

@export var max_value: float

@export var step: float

signal value_changed(value: float)

func init(initial_value: float) -> void:
    var slider = get_node("Slider")

    slider.step = step
    slider.value = initial_value
    slider.min_value = min_value
    slider.max_value = max_value

    var label_node = get_node("TopContainer/Label")
    label_node.text = label

    var value_label_node = get_node("TopContainer/ValueLabel")
    value_label_node.text = str(initial_value)

    var min_label_node = get_node("BottomContainer/MinLabel")
    min_label_node.text = str(min_value)

    var max_label_node = get_node("BottomContainer/MaxLabel")
    max_label_node.text = str(max_value)

    slider.value_changed.connect(func(value: float):
        value_changed.emit(value)
        value_label_node.text = str(snappedf(value, 0.01))
    )
