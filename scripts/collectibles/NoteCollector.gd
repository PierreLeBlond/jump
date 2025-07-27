extends Area2D

class_name NoteCollector

var collected_notes: Array[Note]

signal note_collected(count: int)

func _ready() -> void:
    area_entered.connect(on_area_entered)

func on_area_entered(note: Note) -> void:
    if (note is not Note):
        return

    collected_notes.append(note)
    note_collected.emit(collected_notes.size())
    note.capture()


func restore(restored_index: int):
    var notes_to_restore = collected_notes.slice(restored_index, collected_notes.size())
    for note in notes_to_restore:
        note.restore()

    collected_notes = collected_notes.slice(0, restored_index)
    note_collected.emit(collected_notes.size())
