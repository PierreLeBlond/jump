extends Area2D

class_name NoteCollector

var collected_note_count: int = 0

signal note_collected(count: int)

func _ready() -> void:
    area_entered.connect(on_area_entered)

func on_area_entered(note: Note) -> void:
    if (note is not Note):
        return

    note.set_collision_layer_value(4, false)

    collected_note_count += 1
    note_collected.emit(collected_note_count)

    note.animation_player.play("fly")
    await note.animation_player.animation_finished

    note.queue_free()