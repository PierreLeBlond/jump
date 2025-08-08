extends Area2D

class_name Collector

var collected_notes: Array[Note]

signal note_collected(count: int)
signal life_collected(count: int)

func _ready() -> void:
    area_entered.connect(on_area_entered)

func on_area_entered(collectible: Node) -> void:
    if (collectible is Note):
        collect_note(collectible)
    elif (collectible is Life):
        collect_life(collectible)

func collect_note(note: Note) -> void:
    collected_notes.append(note)
    note_collected.emit(1)
    note.capture()

func collect_life(life: Life) -> void:
    life_collected.emit(1)
    life.capture()

func restore(restored_index: int):
    var notes_to_restore = collected_notes.slice(restored_index, collected_notes.size())
    for note in notes_to_restore:
        note.restore()

    collected_notes = collected_notes.slice(0, restored_index)
    note_collected.emit(-notes_to_restore.size())
