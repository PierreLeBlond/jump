extends Node

class_name EventDispatcher

signal player_unlocked_keys_changed(unlocked_keys: UnlockedKeys)

func emit_player_unlocked_keys_changed(unlocked_keys: UnlockedKeys) -> void:
    player_unlocked_keys_changed.emit(unlocked_keys)