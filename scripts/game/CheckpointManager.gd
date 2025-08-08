extends Node

class_name CheckpointManager

@export var start_checkpoint: Checkpoint

signal checkpoint_saved()
signal checkpoint_loaded()

var checkpoints: Array[Checkpoint] = []
var current_checkpoint: Checkpoint = null

func activate_checkpoints(node: Node, game_run: GameRun) -> void:
    start_checkpoint.game_run = game_run
    start_checkpoint.save()

    for child in node.find_children("*"):
        if child is Checkpoint && child != start_checkpoint:
            checkpoints.append(child)

    for checkpoint in checkpoints:
        checkpoint.game_run = game_run
        checkpoint.checkpoint_saved.connect(on_checkpoint_saved)

    current_checkpoint = start_checkpoint
    
func on_checkpoint_saved(checkpoint: Checkpoint) -> void:
    current_checkpoint = checkpoint
    checkpoint_saved.emit()

func load() -> void:
    if (current_checkpoint == null):
        return

    await current_checkpoint.load()
    checkpoint_loaded.emit()
