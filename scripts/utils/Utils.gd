extends Node

class_name Utils

static func format_time(time: float) -> String:
    var minutes = int(time / 60)
    var seconds = int(time) % 60
    var centiseconds = int((time - (seconds + minutes * 60)) * 100)

    var minutes_string = str(minutes) if minutes > 9 else "0" + str(minutes)
    var seconds_string = str(seconds) if seconds > 9 else "0" + str(seconds)
    var centiseconds_string = str(centiseconds) if centiseconds > 9 else "0" + str(centiseconds)

    return "%s:%s.%s" % [minutes_string, seconds_string, centiseconds_string]