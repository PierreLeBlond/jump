extends Area2D

class_name NoteCollector

var collected_note_count: int = 0

signal note_collected(count: int)

func _ready() -> void:
    area_entered.connect(on_area_entered)

func on_area_entered(collectible_area: Area2D) -> void:
    collectible_area.queue_free()
    collected_note_count += 1
    note_collected.emit(collected_note_count)