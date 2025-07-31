extends Counter

class_name TimeCounter

func update_time_counter(value: float) -> void:
    var minutes = int(value / 60)
    var seconds = int(value) % 60
    var centiseconds = int((value - seconds) * 100)

    var minutes_string = str(minutes) if minutes > 9 else "0" + str(minutes)
    var seconds_string = str(seconds) if seconds > 9 else "0" + str(seconds)
    var centiseconds_string = str(centiseconds) if centiseconds > 9 else "0" + str(centiseconds)

    counter_label.text = minutes_string + ":" + seconds_string + ":" + centiseconds_string