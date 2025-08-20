extends Node

class_name EventDispatcher

signal soubalien_appears

signal race_pre_starts
signal countdown_starts
signal race_starts
signal race_ends

signal note_collected
signal combo_updated(duration: float, count: int)

signal player_unlocked_keys_changed(unlocked_keys: UnlockedKeys)

signal soubalien_captured
signal portal_captured
signal portal_released

func emit_soubalien_appears() -> void:
    soubalien_appears.emit()

func emit_race_pre_starts() -> void:
    race_pre_starts.emit()

func emit_countdown_starts() -> void:
    countdown_starts.emit()

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

func emit_soubalien_captured() -> void:
    soubalien_captured.emit()

func emit_portal_captured() -> void:
    portal_captured.emit()

func emit_portal_released() -> void:
    portal_released.emit()