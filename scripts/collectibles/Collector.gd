extends Area2D

class_name Collector

var collected_notes: Array[Note]

signal note_collected()
signal life_collected()

func _ready() -> void:
    area_entered.connect(on_area_entered)

func on_area_entered(collectible: Node) -> void:
    if (collectible is Note):
        collect_note(collectible)
    elif (collectible is Life):
        collect_life(collectible)

func collect_note(note: Note) -> void:
    collected_notes.append(note)
    note_collected.emit()
    note.capture()

func collect_life(life: Life) -> void:
    life_collected.emit()
    life.capture()