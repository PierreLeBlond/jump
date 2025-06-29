extends Label

class_name CollectorLabel

@export var collector: NoteCollector

func _ready() -> void:
    collector.note_collected.connect(on_note_collected)

func on_note_collected(count: int) -> void:
    if count < 10:
        text = "0" + str(count)
    else:
        text = str(count)