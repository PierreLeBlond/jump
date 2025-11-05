extends HSlider

class_name VolumeSlider

const MAX_VALUE: float = 100.0

@export var bus_name: String

var _bus_index: int

func _ready() -> void:
    _bus_index = AudioServer.get_bus_index(bus_name)

    value_changed.connect(on_value_changed)

    value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index)) * MAX_VALUE

func on_value_changed(changed_value: float) -> void:
    AudioServer.set_bus_volume_db(_bus_index, linear_to_db(changed_value / MAX_VALUE))