extends Node

class_name GameStateManager

@export var checkpoint_manager: CheckpointManager

var game_state: GameState = GameState.new()

func _ready() -> void:
    checkpoint_manager.checkpoint_saved.connect(on_checkpoint_saved)
    checkpoint_manager.checkpoint_loaded.connect(on_checkpoint_loaded)

func on_checkpoint_saved(world: World) -> void:
    game_state.score = world.game_run.score
    game_state.time = world.game_run.elapsed_time

    for note in world.player.collector.collected_notes:
        game_state.notes.append(world.notes.find(note))

func on_checkpoint_loaded(world: World) -> void:
    world.game_run.score = game_state.score
    world.game_run.elapsed_time = game_state.time

    for index in game_state.notes:
        var note = world.notes[index]
        note.capture()
        world.player.collector.collected_notes.append(note)
