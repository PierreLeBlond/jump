extends Node

class_name EventDispatcher

signal soubalien_appears
signal race_starts
signal race_ends
signal note_collected
signal combo_updated(duration: float, count: int)

signal player_unlocked_keys_changed(unlocked_keys: UnlockedKeys)