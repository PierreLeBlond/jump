extends Area2D

class_name Collector

const DEFAULT_COMBO_DURATION: float = 1.0

var collected_notes: Array[Note]

signal note_collected(count: int)
signal note_restored(count: int)
signal life_collected(count: int)

signal combo_updated(duration: float, count: int)
signal combo_ended()

var combo_count: int = 0
var combo_timer: Timer

var combo_duration: float = DEFAULT_COMBO_DURATION

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

    update_combo()

func collect_life(life: Life) -> void:
    life_collected.emit(1)
    life.capture()

func restore(restored_index: int):
    var notes_to_restore = collected_notes.slice(restored_index, collected_notes.size())
    for note in notes_to_restore:
        note.restore()

    collected_notes = collected_notes.slice(0, restored_index)
    note_restored.emit(collected_notes.size())

func update_combo() -> void:
    combo_count += 1
    if combo_timer:
        combo_timer.stop()
        combo_timer.timeout.disconnect(on_combo_timeout)
        combo_timer = null
    combo_timer = Timer.new()
    combo_timer.wait_time = combo_duration
    combo_timer.one_shot = true
    add_child(combo_timer)
    combo_timer.start()
    combo_timer.timeout.connect(on_combo_timeout)
    combo_updated.emit(combo_duration, combo_count)

func on_combo_timeout() -> void:
    combo_count = 0
    combo_ended.emit()
