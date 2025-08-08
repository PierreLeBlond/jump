extends Area2D

class_name Checkpoint

signal checkpoint_saved(checkpoint: Checkpoint)
signal checkpoint_pre_loaded()
signal checkpoint_loaded()

@export var player: ProjectileCharacter
@export var portal: Portal
@export var game_run: GameRun

var collected_notes_index: int = 0
var saved_time: float = 0.0

func _ready() -> void:
    body_entered.connect(on_body_entered)

func on_body_entered(_body: Node2D):
    save()

func save():
    body_entered.disconnect(on_body_entered)

    collected_notes_index = player.note_collector.collected_notes.size()

    if game_run:
        saved_time = game_run.accumulated_time

    checkpoint_saved.emit(self)

func load():
    if game_run:
        game_run.accumulated_time = saved_time

    player.note_collector.restore(collected_notes_index)

    portal.hold_player()
    checkpoint_pre_loaded.emit()
    await portal.release_player()
    checkpoint_loaded.emit()
