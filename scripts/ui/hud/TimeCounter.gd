extends Counter

class_name TimeCounter

func update_time_counter(value: float) -> void:
    counter_label.text = Utils.format_time(value)