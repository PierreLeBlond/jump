extends Node

class_name EventDispatcher

signal soubalien_appears
signal race_starts
signal race_ends
signal note_collected
signal combo_updated(duration: float, count: int)

signal player_unlocked_keys_changed(unlocked_keys: UnlockedKeys)

func emit_soubalien_appears() -> void:
    soubalien_appears.emit()

func emit_race_starts() -> void:
    race_starts.emit()

func emit_race_ends() -> void:
    race_ends.emit()
    
func emit_note_collected() -> void:
    note_collected.emit()

func emit_combo_updated(duration: float, count: int) -> void:
    combo_updated.emit(duration, count)

func emit_player_unlocked_keys_changed(unlocked_keys: UnlockedKeys) -> void:
    player_unlocked_keys_changed.emit(unlocked_keys)