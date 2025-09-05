extends Node

class_name GameStateManager

@export var checkpoint_manager: CheckpointManager

@export var player: ProjectileCharacter
@export var game_run: GameRun

var game_state: GameState = GameState.new()

func _ready() -> void:
    checkpoint_manager.checkpoint_saved.connect(on_checkpoint_saved)
    checkpoint_manager.checkpoint_loaded.connect(on_checkpoint_loaded)

func on_checkpoint_saved() -> void:
    game_state.score = game_run.score
    game_state.time = game_run.elapsed_time
    game_state.notes = player.collector.collected_notes.duplicate()
    game_state.player_position = player.global_position

func on_checkpoint_loaded() -> void:
    game_run.score = game_state.score
    game_run.elapsed_time = game_state.time

    game_run.end_combo()

    for note in player.collector.collected_notes:
        if not note in game_state.notes:
            note.restore()

    player.collector.collected_notes = game_state.notes.duplicate()
